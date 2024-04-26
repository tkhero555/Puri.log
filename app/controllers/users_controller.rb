class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @recommend_meals = current_user.meals.where('score >= ?', 3)
    if @recommend_meals.nil?
      @recommend_meals = current_user.meals.where('score >= ?', 1)
    end
    @avert_meals = current_user.meals.where('score <= ?', -3)
    if @avert_meals.nil?
      @avert_meals = current_user.meals.where('score >= ?', 1)
    end

    meal_log_index = current_user.eatings.includes(:meal)
    stool_log_index = current_user.stools
    meal_log_index = meal_log_index.to_a
    stool_log_index = stool_log_index.to_a
    @log_index = meal_log_index.concat(stool_log_index)
    @log_index = @log_index.sort_by do |log|
      if log.is_a?(Eating)
        log.eated_at
      elsif log.is_a?(Stool)
        log.created_at
      end
    end
  end
end
