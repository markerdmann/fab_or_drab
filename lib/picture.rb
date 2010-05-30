class Picture < Ohm::Model
  attribute :id
  attribute :data
  attribute :url
  collection :votes, Vote
  reference :user, User

  def filename
    self.id + ".jpg"
  end
end
