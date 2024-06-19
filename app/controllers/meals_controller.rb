class MealsController < ApplicationController

  def create
    user_id = current_user.id
    if params[:meal_name].present?
      meal_name = params[:meal_name]
    else
      meal_name = params[:new_meal_name]
    end
    meal = Meal.find_by(meal_name: meal_name, user_id: user_id)
    if meal.present?
      meal_id = meal.id
    else
      meal = Meal.new(meal_name: meal_name, user_id: user_id)
      if meal.save
        meal_id = meal.id
      else
        flash[:alert] = '食事の記録に失敗しました'
        redirect_to user_path
        p "meal.saveの失敗"
        return
      end
    end
    eating = Eating.new(user_id: user_id, meal_id: meal_id, created_at: params[:meal_created_at])
    if eating.save
      flash[:notice] = '食事を記録しました'
      redirect_to user_path
    else
      flash[:alert] = '食事の記録に失敗しました'
      redirect_to user_path
      p "eating.saveの失敗"
    end
  end

  def destroy 
  end
end
