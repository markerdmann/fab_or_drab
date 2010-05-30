class User < Ohm::Model
  attribute :token
  attribute :secret
  collection :pictures, Picture

  index :token
  index :secret
end
