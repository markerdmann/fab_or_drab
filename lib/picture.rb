class Picture < Ohm::Model
  attribute :data
  attribute :uri
  collection :votes, Vote
  reference :user, User
end
