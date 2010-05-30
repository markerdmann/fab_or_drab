class Vote < Ohm::Model
  attribute :rating
  reference :picture, Picture

  index :rating
end
