class EatingsController < ApplicationController
  def destroy
    eating = Eating.find(params[:id])
    eating.destroy!
    redirect_to user_url(current_user), status: :see_other
  end
end
