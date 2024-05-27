class StoolsController < ApplicationController

  def create
    if params[:condition] == ""
      condition = 1
    else
      condition = params[:condition].to_i
    end
    stool = Stool.new(condition: condition, user_id: current_user.id, created_at:params[:created_at])
    unless stool.save
      flash.now[:danger] = '排便の記録に失敗しました'
      render("user/show")
      return
    end
    if condition == 0
      score_change = 1
    elsif condition == 2
      score_change = -1
    else
      flash[:notice] = '排便を記録しました'
      redirect_to user_path(current_user)
      return
    end
    start_time = stool.created_at - 50.hours
    end_time = stool.created_at - 20.hours
    eatings = Eating.where(created_at: start_time..end_time).where(user_id: current_user.id)
    eatings.each do |eating|
      meal = Meal.find(eating.meal_id)
      unless meal.update(score: meal.score + score_change)
        flash.now[:alert] = '排便の記録に失敗しました'
        redirect_to user_path(current_user) and return
      end
    end
    flash[:notice] = '排便を記録しました'
    redirect_to user_path(current_user)
  end

  def destroy
    stool = Stool.find(params[:id])
    if stool.condition == "good"
      score_change = -1
    elsif stool.condition == "bad"
      score_change = 1
    else
      score_change = 0
    end
    start_time = stool.created_at - 50.hours
    end_time = stool.created_at - 20.hours
    eatings = Eating.where(created_at: start_time..end_time).where(user_id: current_user.id)
    eatings.each do |eating|
      meal = Meal.find(eating.meal_id)
      unless meal.update(score: meal.score + score_change)
        flash.now[:alert] = '記録の削除に失敗しました。'
        redirect_to user_path(current_user) and return
      end
    end
    stool.destroy!
    set_log_index
  end
end
