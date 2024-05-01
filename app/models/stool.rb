class Stool < ApplicationRecord
  belongs_to :user
  enum condition: { good: 0, normal: 1, bad: 2 }
  validates :condition, presence: true, length: { maximum: 30 }
end
