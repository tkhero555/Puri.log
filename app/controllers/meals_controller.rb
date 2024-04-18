class MealsController < ApplicationController

  # def index; end

  # def new; end

  def create
    user_id = current_user.id
    meal = Meal.find_by(meal_name: params[:meal_name])
    if meal.present?
      meal_id = meal.id
    else
      meal = Meal.new(meal_name: params[:meal_name], user_id: user_id)
      meal.save
      meal_id = meal.id
    end
    evaluation = Evaluation.new(user_id: user_id, meal_id: meal_id, eated_at: params[:eated_at])
    if evaluation.save
      flash[:notice] = '食事を記録しました'
      redirect_to user_path(current_user)
    else
      flash.now[:danger] = '食事の記録に失敗しました'
      render("user/show")
    end
  end

  # def show; end

  # def edit; end

  # def update; end

  # def destroy; end

  private

  #def meal_params
   # params.require(:).permit()
end
