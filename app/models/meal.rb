class Meal < ApplicationRecord
  belongs_to :user
  has_many :evaluations
end
