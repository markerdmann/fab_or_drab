#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'twitter_oauth'
require 'redis'
require 'aws/s3'
require 'json'
require 'httparty'

require File.expand_path(File.join(File.dirname(__FILE__), 'init.rb'))

include AWS::S3

configure do
  set :sessions, true
  @@config = YAML.load_file("config.yml") rescue nil || {}
  Ohm.redis=Ohm.connection(:port =>6379, 
                           :db => @@config["redis_db"] || 0,
                           :thread_safe => true,
                           :host => ENV['REDIS_HOST'] || @@config["redis_host"] || "127.0.0.1")
  $redis = Ohm.redis

  AWS::S3::Base.establish_connection!(
    :access_key_id     => ENV['S3_ACCESS_KEY_ID'] || @@config["s3_access_key_id"],
    :secret_access_key => ENV['S3_SECRET_ACCESS_KEY'] || @@config["s3_secret_access_key"]
  )
end

before do
  next if request.path_info =~ /ping$/
  @user = session[:user]
  @client = TwitterOAuth::Client.new(
    :consumer_key => ENV['CONSUMER_KEY'] || @@config['consumer_key'],
    :consumer_secret => ENV['CONSUMER_SECRET'] || @@config['consumer_secret'],
    :token => session[:access_token],
    :secret => session[:secret_token]
  )
  @rate_limit_status = @client.rate_limit_status
end

get '/' do
  redirect '/timeline' if @user
  @trends = @client.current_trends
  @tweets = @client.public_timeline
  erb :home
end

get '/timeline' do
  @tweets = @client.friends_timeline
  erb :timeline
end

post '/update' do
  @client.update(params[:update])
  redirect '/timeline'
end

get '/messages' do
  @sent = @client.sent_messages
  @received = @client.messages
  erb :messages
end

get '/search' do
  params[:q] ||= 'sinitter OR twitter_oauth'
  @search = @client.search(params[:q], :page => params[:page], :per_page => params[:per_page])
  erb :search
end

get '/upload' do
  
  erb :upload
  
end

post '/upload' do
  
  image_file = params[:datafile][:tempfile]
  id = rand(10**20).to_s
  filename = id + ".jpg"
  S3Object.store(
      filename,
      image_file.read,
      'fabordrab',
      :access => :public_read
    )
  url = "http://s3.amazonaws.com/fabordrab/#{filename}"
  $redis.set(id, url)
  $redis.sadd("images", url)
  
  base_uri = @@config['base_uri']
  vote_url = base_uri + "/vote/#{id}"
  response = HTTParty.get("http://api.bit.ly/v3/shorten?login=markerdmann&apiKey=R_d7a6c79cf48989e6e9355bd4a6d96da2&longUrl=#{vote_url}")
  puts response.inspect
  short_url = response['data']['url']
  puts short_url.inspect
  @client.update(short_url)
  
  redirect "/vote/#{id}"
  
end

get '/vote' do
  
  @url = $redis.srandmember("images")
  puts @url.inspect
  erb :vote
  
end

get '/vote/:id' do
  
  id = params[:id]
  @url = $redis.get(id)
  puts @url.inspect
  erb :vote
  
end

# store the request tokens and send to Twitter
get '/connect' do
  request_token = @client.request_token(
    :oauth_callback => ENV['CALLBACK_URL'] || @@config['callback_url']
  )
  session[:request_token] = request_token.token
  session[:request_token_secret] = request_token.secret
  redirect request_token.authorize_url.gsub('authorize', 'authenticate') 
end

# auth URL is called by twitter after the user has accepted the application
# this is configured on the Twitter application settings page
get '/auth' do
  # Exchange the request token for an access token.
  
  begin
    @access_token = @client.authorize(
      session[:request_token],
      session[:request_token_secret],
      :oauth_verifier => params[:oauth_verifier]
    )
  rescue OAuth::Unauthorized
  end
  
  if @client.authorized?
      # Storing the access tokens so we don't have to go back to Twitter again
      # in this session.  In a larger app you would probably persist these details somewhere.
      session[:access_token] = @access_token.token
      session[:secret_token] = @access_token.secret
      session[:user] = true
      redirect '/timeline'
    else
      redirect '/'
  end
end

get '/disconnect' do
  session[:user] = nil
  session[:request_token] = nil
  session[:request_token_secret] = nil
  session[:access_token] = nil
  session[:secret_token] = nil
  redirect '/'
end

# useful for site monitoring
get '/ping' do 
  'pong'
end

helpers do 
  def partial(name, options={})
    erb("_#{name.to_s}".to_sym, options.merge(:layout => false))
  end
end
