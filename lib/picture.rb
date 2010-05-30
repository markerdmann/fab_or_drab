class Picture < Ohm::Model
  attribute :name
  attribute :data
  attribute :url
  collection :votes, Vote
  reference :user, User

  index :name
  def filename
    self.name + ".jpg"
  end

  def self.hash_name(name)
    "PICTURES:NAME:#{name}".hash.abs.to_s(16)
  end
end
