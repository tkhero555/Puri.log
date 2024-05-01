class Meal < ApplicationRecord
  belongs_to :user
  has_many :eatings, dependent: :destroy
  validates :meal_name, presence: true, length: { maximum: 30 }
end
