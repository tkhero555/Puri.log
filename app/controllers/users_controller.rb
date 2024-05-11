class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    # おすすめの食事用のインスタンス変数
    @recommend_meals = current_user.meals.where('score >= ?', 3)
    if @recommend_meals.nil?
      @recommend_meals = current_user.meals.where('score >= ?', 1)
    end
    # 避けるべき食事用のインスタンス変数
    @avert_meals = current_user.meals.where('score <= ?', -3)
    if @avert_meals.nil?
      @avert_meals = current_user.meals.where('score >= ?', 1)
    end

    # 記録履歴一覧用のインスタンス変数
    meal_log_index = current_user.eatings.includes(:meal)
    stool_log_index = current_user.stools
    meal_log_index = meal_log_index.to_a
    stool_log_index = stool_log_index.to_a
    @log_index = meal_log_index.concat(stool_log_index)
    @log_index = @log_index.sort_by do |log|
      if log.is_a?(Eating)
        log.created_at
      elsif log.is_a?(Stool)
        log.created_at
      end
    end

    # 通算記録回数表示用のインスタンス変数
    @eating_count = current_user.eatings.count
    @stool_count = current_user.stools.count
    @log_count = @eating_count + @stool_count
    # 今月の記録回数表示用のインスタンス変数
    @this_month_eating_count = current_user.eatings.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).count
    @this_month_stool_count = current_user.stools.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).count
    # 先月の記録回数表示用のインスタンス変数
    @last_month_eating_count = current_user.eatings.where(created_at: Time.current.last_month.beginning_of_month..Time.current.last_month.end_of_month).count
    @last_month_stool_count = current_user.stools.where(created_at: Time.current.last_month.beginning_of_month..Time.current.last_month.end_of_month).count

    # 登録済みの食事メニュー一覧用のインスタンス変数
    @my_meal_count = current_user.eatings.group(:meal_id).count
    @meals = current_user.meals
  end
end
