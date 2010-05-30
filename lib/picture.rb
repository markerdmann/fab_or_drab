class Picture < Ohm::Model
  attribute :data
  attribute :uri
  collection :judgments, Judgment
  counter :votes
  reference :user, User
end
