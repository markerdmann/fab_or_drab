class Judgment < Ohm::Model
  attribute :rating
  reference :picture, Picture
end
