class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  private

  # 記録履歴一覧用のインスタンス変数を作成、並び替え
  def set_log_index
    meal_log_index = current_user.eatings.includes(:meal).to_a
    stool_log_index = current_user.stools.to_a
    @log_index = meal_log_index.concat(stool_log_index)
    if params[:desc]
      @log_index = @log_index.sort_by { |log| log.created_at }.reverse
      session[:sort] = "desc"
    elsif params[:asc]
      @log_index = @log_index.sort_by { |log| log.created_at }
      session[:sort] = "asc"
    else
      if session[:sort] == "desc"
        @log_index = @log_index.sort_by { |log| log.created_at }.reverse
        session[:sort] = "desc"
      elsif session[:sort] == "asc"
        @log_index = @log_index.sort_by { |log| log.created_at }
        session[:sort] = "asc"
      end
    end
  end
end
