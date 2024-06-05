class Eating < ApplicationRecord
  belongs_to :user
  belongs_to :meal

  scope :this_month, -> { where(created_at: Time.current.beginning_of_month..Time.current.end_of_month) }
  scope :last_month, -> { where(created_at: Time.current.last_month.beginning_of_month..Time.current.last_month.end_of_month) }

  # Eatingモデルに関連する定数の設定
  # 排便の原因となる食事を特定する時間範囲
  DETERMINING_COMPATIBILITY_START_TIME = 50
  DETERMINING_COMPATIBILITY_END_TIME = 20
end
