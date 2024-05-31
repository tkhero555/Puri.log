class Meal < ApplicationRecord
  belongs_to :user
  has_many :eatings, dependent: :destroy
  validates :meal_name, presence: true, length: { maximum: 30 }

  # Mealモデルに関連する定数の設定
  # 食事score変動用
  MEAL_SCORE_CHANGE_ZERO = 0
  MEAL_SCORE_CHANGE_PLUS = 1
  MEAL_SCORE_CHANGE_MINUS = 2

  # おすすめの食事と避けるべき食事の判定基準の値
  RECOMMEND_MEAL_JUDGE_FIRST_POINT = 3
  RECOMMEND_MEAL_JUDGE_SECOND_POINT = 1
  AVERT_MEAL_JUDGE_FIRST_POINT = -3
  AVERT_MEAL_JUDGE_SECOND_POINT = -1
end
