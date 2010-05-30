class Vote < Ohm::Model
  attribute :rating
  reference :picture, Picture
end
