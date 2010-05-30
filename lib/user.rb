class User < Ohm::Model
  attribute :email
  attribute :token
  attribute :secret_token
  collection :pictures, Picture
end
