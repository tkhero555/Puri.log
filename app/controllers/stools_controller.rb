class StoolsController < ApplicationController

  def create
    stool = Stool.new(condition: params[:condition].to_i, user_id: current_user.id, created_at:params[:created_at])
    unless stool.save
      flash.now[:danger] = '排便の記録に失敗しました'
      render("user/show")
      return
    end
    if params[:condition].to_i == 0
      score_change = 1
    elsif params[:condition].to_i == 2
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
      p meal
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
    stool.destroy!
    redirect_to user_url(current_user), status: :see_other
  end
end
