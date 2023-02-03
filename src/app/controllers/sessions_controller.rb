class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to 'https://railstutorial.jp/', allow_other_host: true
      # redirect_to root_path

    else
      flash[:error_messages] = ["Eメールまたはパスワードが正しくありません"] # Array型で格納
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end
end

