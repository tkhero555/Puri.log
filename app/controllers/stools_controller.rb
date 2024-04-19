class StoolsController < ApplicationController

  def create
    stool = Stool.new(condition: params[:condition].to_i, user_id: current_user.id)
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
    evaluations = Evaluation.where(eated_at: 50.hours.ago..20.hours.ago).where(user_id: current_user.id)
    evaluations.each do |evaluation|
      unless evaluation.update(score: evaluation.score + score_change)
        flash.now[:danger] = '排便の記録に失敗しました'
        render("user/show")
        return
      end
    end
    flash[:notice] = '排便を記録しました'
    redirect_to user_path(current_user)
  end
end
