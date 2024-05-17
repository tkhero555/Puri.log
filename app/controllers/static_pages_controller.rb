class StaticPagesController < ApplicationController
  def index 
    @number = session[:number] || 1
  end

  def increment
    @number = (session[:number] || 0) + 1
    if @number >= 9
      @number = 1
      session[:number] = @number
    else
      session[:number] = @number
    end
  end

  def decrement
    @number = (session[:number] || 0) - 1
    if @number <= 0
      @number = 8
      session[:number] = @number
    else
      session[:number] = @number
    end
  end
end
