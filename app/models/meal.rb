class Meal < ApplicationRecord
  belongs_to :user
  has_many :eatings, dependent: :destroy
end
