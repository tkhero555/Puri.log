class StaticPagesController < ApplicationController

  def index 
    @number = session[:number] || EXPLAIN_MIN_PAGE
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
end
