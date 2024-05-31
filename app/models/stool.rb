class Stool < ApplicationRecord
  belongs_to :user
  enum condition: { good: 0, normal: 1, bad: 2 }
  validates :condition, presence: true, length: { maximum: 30 }

  scope :this_month, -> { where(created_at: Time.current.beginning_of_month..Time.current.end_of_month) }
  scope :last_month, -> { where(created_at: Time.current.last_month.beginning_of_month..Time.current.last_month.end_of_month) }
  scope :condition_is, ->(condition) { where(condition: condition) }

  # Stoolモデルに関連する定数の設定
  # 排便記録のenumの値確認用
  STOOL_LOG_CONDITION_GOOD = 0
  STOOL_LOG_CONDITION_NORMAL = 1
  STOOL_LOG_CONDITION_BAD = 2
end
