class StaticPagesController < ApplicationController

  def index 
    @number = session[:number] || EXPLAIN_MIN_PAGE
  end

  def policy
  end

  def terms
  end

  def increment
    @number = (session[:number] || EXPLAIN_MIN_PAGE) + PAGE_NUMBER_PLUS
    if @number >= EXPLAIN_MAX_PAGE + PAGE_NUMBER_PLUS
      @number = EXPLAIN_MIN_PAGE
      session[:number] = @number
    else
      session[:number] = @number
    end
  end

  def decrement
    @number = (session[:number] || EXPLAIN_MIN_PAGE) + PAGE_NUMBER_MINUS
    if @number <= EXPLAIN_MIN_PAGE + PAGE_NUMBER_MINUS
      @number = EXPLAIN_MAX_PAGE
      session[:number] = @number
    else
      session[:number] = @number
    end
  end

  # トップページで使用する定数の設定
  # 詳しい説明の最小と最大ページ番号
  EXPLAIN_MIN_PAGE = 1
  EXPLAIN_MAX_PAGE = 8

  # 詳しい説明のページ移行用の値
  PAGE_NUMBER_PLUS = 1
  PAGE_NUMBER_MINUS = -1
end
