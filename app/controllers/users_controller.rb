class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    # おすすめの食事用のインスタンス変数
    @recommend_meals = current_user.meals.where('score >= ?', Meal::RECOMMEND_MEAL_JUDGE_FIRST_POINT)
    if @recommend_meals.nil?
      @recommend_meals = current_user.meals.where('score >= ?', Meal::RECOMMEND_MEAL_JUDGE_SECOND_POINT)
    end
    # 避けるべき食事用のインスタンス変数
    @avert_meals = current_user.meals.where('score <= ?', Meal::AVERT_MEAL_JUDGE_FIRST_POINT)
    if @avert_meals.nil?
      @avert_meals = current_user.meals.where('score >= ?', Meal::AVERT_MEAL_JUDGE_SECOND_POINT)
    end

    # 記録履歴一覧用のインスタンス変数
    set_log_index

    # 通算記録回数表示用のインスタンス変数
    @eating_count = current_user.eatings.count
    @stool_count = current_user.stools.count
    @log_count = @eating_count + @stool_count
    # 今月の記録回数表示用のインスタンス変数
    @this_month_eating_count = current_user.eatings.this_month.count
    @this_month_stool_count = current_user.stools.this_month.count
    # 先月の記録回数表示用のインスタンス変数
    @last_month_eating_count = current_user.eatings.last_month.count
    @last_month_stool_count = current_user.stools.last_month.count

    # 登録済みの食事メニュー一覧用のインスタンス変数
    @my_meal_count = current_user.eatings.group(:meal_id).count
    @meals = current_user.meals

    # 通算の胃腸の状況用のインスタンス変数
    @stool_good_count = current_user.stools.condition_is("good").count
    @stool_normal_count = current_user.stools.condition_is("normal").count
    @stool_bad_count = current_user.stools.condition_is("bad").count
    # 今月の胃腸の状況用のインスタンス変数
    @this_month_stool_good_count = current_user.stools.condition_is("good").this_month.count
    @this_month_stool_normal_count = current_user.stools.condition_is("normal").this_month.count
    @this_month_stool_bad_count = current_user.stools.condition_is("bad").this_month.count
    # 先月の胃腸の状況用のインスタンス変数
    @last_month_stool_good_count = current_user.stools.condition_is("good").last_month.count
    @last_month_stool_normal_count = current_user.stools.condition_is("normal").last_month.count
    @last_month_stool_bad_count = current_user.stools.condition_is("bad").last_month.count

    # 連続記録日数のインスタンス変数
    @meal_log_days_record = current_user.set_instance_meal_log_days
    @stool_log_days_record = current_user.set_instance_stool_log_days

    # 記録済みテストユーザーのIDを格納する
    @recorded_test_user_id = User::RECORDED_TEST_USER_ID
  end

  def destroy
    user = current_user
    user.destroy!
    flash[:notice] = 'ユーザーを削除しました。'
    redirect_to root_path
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
end
