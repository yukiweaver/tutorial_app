class SessionsController < ApplicationController
  def new
  end
  
  # ログイン
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_back_or(user)  # SessionsHellper
    else
      flash.now[:danger] = "メールアドレスとパスワードの情報が一致しませんでした。"
      render 'new'
    end
  end
  
  # ログアウト
  def destroy
    log_out
    redirect_to root_path
  end
end
