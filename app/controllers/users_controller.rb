class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @recommend_meals = current_user.evaluations.includes(:meal).where('score >= ?', 3)
    @avert_meals = current_user.evaluations.includes(:meal).where('score <= ?', -3)
  end
end
