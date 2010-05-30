class User < Ohm::Model
  attribute :handle
  collection :pictures, Picture

  index :handle
  def stats
    pictures
  end
end
