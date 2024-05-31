class Eating < ApplicationRecord
  belongs_to :user
  belongs_to :meal

  scope :this_month, -> { where(created_at: Time.current.beginning_of_month..Time.current.end_of_month) }
  scope :last_month, -> { where(created_at: Time.current.last_month.beginning_of_month..Time.current.last_month.end_of_month) }
end
