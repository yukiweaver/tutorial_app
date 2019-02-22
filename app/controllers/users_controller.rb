class UsersController < ApplicationController
  
  # 新規登録ページ
  def new
    @user = User.new
  end
  
  # 勤怠表示ページ
  def show
    @user = User.find(params[:id])
  end
  
  # 新規登録→ログイン状態へ
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "ユーザーの新規作成に成功しました。"
      redirect_to @user
    else
      render "new"
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
