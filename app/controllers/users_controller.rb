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
  end
end
