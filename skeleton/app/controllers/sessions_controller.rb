class SessionsController < ApplicationController
  before_action :require_login, only: [:destroy]
  before_action :require_logout, only: [:new, :create]
  
  def new
    @user = User.new
    render :new
  end
  
  def create # LOGIN
    user = User.find_by_credentials(params[:user][:username], params[:user][:password])
    # debugger
    if user  
      login!(user)
      #render :new
      redirect_to user_url(user)
    else
      flash.now[:errors] = ["Invalid credentials"]
      render :new
    end
  end
  
  def destroy # LOG OUT
    logout!
    redirect_to new_session_url
  end
  
end