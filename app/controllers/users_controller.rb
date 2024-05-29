class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    # おすすめの食事用のインスタンス変数
    @recommend_meals = current_user.meals.where('score >= ?', 3)
    if @recommend_meals.nil?
      @recommend_meals = current_user.meals.where('score >= ?', 1)
    end
    # 避けるべき食事用のインスタンス変数
    @avert_meals = current_user.meals.where('score <= ?', -3)
    if @avert_meals.nil?
      @avert_meals = current_user.meals.where('score >= ?', 1)
    end

    # 記録履歴一覧用のインスタンス変数
    set_log_index

    # 通算記録回数表示用のインスタンス変数
    @eating_count = current_user.eatings.count
    @stool_count = current_user.stools.count
    @log_count = @eating_count + @stool_count
    # 今月の記録回数表示用のインスタンス変数
    @this_month_eating_count = current_user.eatings.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).count
    @this_month_stool_count = current_user.stools.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).count
    # 先月の記録回数表示用のインスタンス変数
    @last_month_eating_count = current_user.eatings.where(created_at: Time.current.last_month.beginning_of_month..Time.current.last_month.end_of_month).count
    @last_month_stool_count = current_user.stools.where(created_at: Time.current.last_month.beginning_of_month..Time.current.last_month.end_of_month).count

    # 登録済みの食事メニュー一覧用のインスタンス変数
    @my_meal_count = current_user.eatings.group(:meal_id).count
    @meals = current_user.meals

    # 通算の胃腸の状況用のインスタンス変数
    @stool_good_count = current_user.stools.where(condition: "good").count
    @stool_normal_count = current_user.stools.where(condition: "normal").count
    @stool_bad_count = current_user.stools.where(condition: "bad").count
    # 今月の胃腸の状況用のインスタンス変数
    @this_month_stool_good_count = current_user.stools.where(condition: "good").where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).count
    @this_month_stool_normal_count = current_user.stools.where(condition: "normal").where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).count
    @this_month_stool_bad_count = current_user.stools.where(condition: "bad").where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).count
    # 先月の胃腸の状況用のインスタンス変数
    @last_month_stool_good_count = current_user.stools.where(condition: "good").where(created_at: Time.current.last_month.beginning_of_month..Time.current.last_month.end_of_month).count
    @last_month_stool_normal_count = current_user.stools.where(condition: "normal").where(created_at: Time.current.last_month.beginning_of_month..Time.current.last_month.end_of_month).count
    @last_month_stool_bad_count = current_user.stools.where(condition: "bad").where(created_at: Time.current.last_month.beginning_of_month..Time.current.last_month.end_of_month).count

    # 連続記録日数のインスタンス変数
    @meal_log_days_record = 0
    @stool_log_days_record = 0
    meal_start_day = Time.zone.now.beginning_of_day
    meal_end_day = Time.zone.now.end_of_day
    stool_start_day = Time.zone.now.beginning_of_day
    stool_end_day = Time.zone.now.end_of_day

    while current_user.eatings.where(created_at: meal_start_day..meal_end_day).exists?
      @meal_log_days_record += 1
      meal_start_day = meal_start_day - 1.day
      meal_end_day = meal_end_day - 1.day
    end
    while current_user.stools.where(created_at: stool_start_day..stool_end_day).exists?
      @stool_log_days_record += 1
      stool_start_day = stool_start_day - 1.day
      stool_end_day = stool_end_day - 1.day
    end
  end

  # 食事記録フォームの入力補助
  def search
    @suggest_meals = Meal.where("meal_name like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.js
    end
  end

  def sort
    set_log_index
  end

  def toggle_notifications
    current_user.notifications_enabled = !current_user.notifications_enabled
    if current_user.save
      flash[:notice] = "通知設定が更新されました。"
    else
      flash[:alert] = "通知設定の更新に失敗しました。"
    end
    redirect_to user_path(current_user)
  end

  def destroy
    user = current_user
    user.destroy!
    flash[:notice] = 'ユーザーを削除しました。'
    redirect_to root_path
  end
end
