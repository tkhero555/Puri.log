class EatingsController < ApplicationController
  def destroy
    eating = Eating.find(params[:id])
    eating.destroy!
    set_log_index
  end
end
