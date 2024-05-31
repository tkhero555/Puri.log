class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  # 定数を定義する
  # 記録済みテストユーザーid
  RECORDED_TEST_USER_ID = 2

  # 排便記録のenumの値確認用
  STOOL_LOG_CONDITION_GOOD = 0
  STOOL_LOG_CONDITION_NORMAL = 1
  STOOL_LOG_CONDITION_BAD = 2

  # 食事score変動用
  MEAL_SCORE_CHANGE_ZERO = 0
  MEAL_SCORE_CHANGE_PLUS = 1
  MEAL_SCORE_CHANGE_MINUS = 2

  # 排便の原因となる食事を特定する時間範囲
  DETERMINING_COMPATIBILITY_START_TIME = 20
  DETERMINING_COMPATIBILITY_END_TIME = 50

  # おすすめの食事と避けるべき食事の判定基準の値
  RECOMMEND_MEAL_JUDGE_FIRST_POINT = 3
  RECOMMEND_MEAL_JUDGE_SECOND_POINT = 1
  AVERT_MEAL_JUDGE_FIRST_POINT = -3
  AVERT_MEAL_JUDGE_SECOND_POINT = -1

  # 詳しい説明の最小と最大ページ番号
  EXPLAIN_MIN_PAGE = 1
  EXPLAIN_MAX_PAGE = 8

  # 詳しい説明のページ移行用の値
  PAGE_NUMBER_PLUS = 1
  PAGE_NUMBER_MINUS = -1

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
