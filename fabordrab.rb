#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'redis'
require 'aws/s3'
require 'json'
require 'httparty'
require 'twitter_oauth/lib/twitter_oauth'

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

  token = session[:access_token]
  secret = session[:secret_token]
  @client = set_client
  @annotation_client = annotation_client
  
  @rate_limit_status = @client.rate_limit_status

  get_user
end

get '/' do
  redirect '/timeline' if @user
  @trends = @client.current_trends
  @tweets = @client.public_timeline

  erb :home
end

get '/timeline' do
  @tweets = @client.friends_timeline

  user = get_user
  @pics = user.pictures if user
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
  params[:q] ||= '#fabordrab'
  @search = @client.search(params[:q], :page => params[:page], :per_page => params[:per_page])
  erb :search
end

get '/mypics' do 
  user = get_user
  redirect '/' unless user

  @pics = user.pictures
  
  erb :mypics
end

get '/upload' do
  
  erb :upload
  
end

post '/upload' do

  image_file = params[:datafile][:tempfile]
  
  annotations = {}
  annotations['product'] = {}
  annotations['product']['category'] = params[:category]
  annotations['product']['brand'] = params[:brand]
  annotations['product']['store'] = params[:store]
  annotations['product']['price'] = params[:price]
  
  puts annotations.inspect
  
  name = Ohm.redis.incr "fabordrab:picture:last_name"
  name_available = Ohm.redis.sadd "fabordrab:picture:names", name

  user = get_user
  picture = Picture.create( :name => Picture.hash_name(name), :data=>[annotations].to_json )
  filename = picture.filename
  s3_url = ENV['S3_URL'] || @@config['s3_url']
  image_url = s3_url + "/" + filename
  picture.update( :url => image_url )
  user.pictures << picture
  
  S3Object.store(
      filename,
      image_file.read,
      'fabordrab',
      :access => :public_read
    )

  base_uri = ENV['BASE_URI'] || @@config['base_uri']
  bitly_login = ENV['BITLY_LOGIN'] || @@config['bitly_login']
  bitly_api_key = ENV['BITLY_API_KEY'] || @@config['bitly_api_key']

  vote_url = base_uri + "/vote/#{picture.name}"
  response = HTTParty.get("http://api.bit.ly/v3/shorten?login=#{bitly_login}&apiKey=#{bitly_api_key}&longUrl=#{vote_url}")
  puts response.inspect
  short_url = response['data']['url']
  puts short_url.inspect
  
  

  @annotation_client = annotation_client
  resp = @annotation_client.post("/1/statuses/update.json", 
                                 {:status => short_url + " #fabordrab",
                                   :annotations => picture.data })
  puts resp.inspect
  picture.update( :tweet_id => JSON.parse(resp.body)["id"] )
  
  
  # post to crowdflower
  cf_key = ENV['CROWDFLOWER_KEY'] || @@config['crowdflower_key']
  HTTParty.post("https://api.crowdflower.com/v1/jobs/12386/units.json?key=#{cf_key}", :body => {:unit => {:data => {:url => image_url, :name => picture.name}}})
  
  redirect "/vote/#{picture.name}"
end

get '/vote' do
  ## yeah we would use sorted set here
  least_judged_picture = Picture.all.to_a.sort { |a,b| a.votes.size <=> b.votes.size }.first
  if( least_judged_picture )
    @name = least_judged_picture.name
    @url = least_judged_picture.url
    puts @url.inspect
    redirect "/vote/#{@name}"
  else
    redirect "/"
  end
end

get '/vote/:name' do
  
  @name = params[:name]
  pic = Picture.first(:name => @name)
  
  if(pic)
    @url = pic.url
    puts @url.inspect

    erb :vote
  else
    redirect "/"
  end
end

post '/fab/:name' do
  name = params[:name]
  rate_picture(name, Picture::FAB)
  redirect "/vote"
end

post '/drab/:name' do
  name = params[:name]
  rate_picture(name, Picture::DRAB)
  redirect "/vote"
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

post '/crowdflower' do
  
  return if params[:signal] != "unit_complete"

  begin
    payload = JSON.parse(params[:payload])
    name = payload['data']['name']
  
    judgments = payload['results']['judgments']
    judgments.each do |judgment|
      begin
        result = judgment['data']['choose_one']
        if result == "Fab"
          HTTParty.post("http://fabordrab.heroku.com/fab/#{name}")
        elsif result == "Drab"
          HTTParty.post("http://fabordrab.heroku.com/drab/#{name}")
        end
      rescue => e
        puts e.inspect
      end
    end
  rescue => e
    puts e.inspect
  end
  
  status 200

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

  def get_tokens
    token = params[:token] || session[:access_token]
    secret = params[:secret] || session[:secret_token]
    return token, secret
  end

  def get_user
    token, secret = get_tokens
    user = User.first_or_create(:token => token, :secret => secret)
  end

  def rate_picture(name, fab_or_drab)
    pic = Picture.first( :name => name )
    vote = Vote.create( :rating => fab_or_drab, :picture => pic ) if pic
  end

  def set_client
    token, secret = get_tokens
    
    TwitterOAuth::Client.new(
                             :consumer_key => ENV['CONSUMER_KEY'] || @@config['consumer_key'],
                             :consumer_secret => ENV['CONSUMER_SECRET'] || @@config['consumer_secret'],
                             :token => token,
                             :secret => secret
                             )

  end

  def annotation_client
    token, secret = get_tokens

    puts "annotation client"
    puts token
    puts secret

    consumer = OAuth::Consumer.new(ENV['CONSUMER_KEY'] || @@config['consumer_key'],
                                   ENV['CONSUMER_SECRET'] || @@config['consumer_secret'], 
                                   { :site => "http://api.twitter.com" })
    access_token = OAuth::AccessToken.new(consumer, token, secret)
  end
end
