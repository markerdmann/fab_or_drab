class Picture < Ohm::Model
  FAB = 1
  DRAB = 0
  
  attribute :name
  attribute :tweet_id
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

  def get_data
    return [] unless data
    JSON.parse(data)
  end
  
  def fabs
    self.votes.inject(0) { |r,v| r += (v.rating.to_i == FAB) ? 1 : 0 }
  end
  
  def drabs
    self.votes.inject(0) { |r,v| r += (v.rating.to_i == DRAB) ? 1 : 0 }
  end
  
  def rating
    self.votes.size > 0 ? self.votes.inject(0) {|r,v| r += v.rating.to_i } / self.votes.size.to_f : 0
  end

  def self.least_judged
    Picture.all.to_a.sort { |a, b| a.votes.size <=> b.votes.size }.first
  end
end
