class Picture < Ohm::Model
  FAB = 1
  DRAB = 0
  
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

  def fabs
    self.votes.inject(0) { |r,v| r += (v.rating.to_i == FAB) ? 1 : 0 }
  end
  
  def drabs
    self.votes.inject(0) { |r,v| r += (v.rating.to_i == DRAB) ? 1 : 0 }
  end
  
  def rating
    self.votes.inject(0) {|r,v| r += v.rating.to_i } / self.votes.size.to_f
  end
end
