class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]
  
  def index
    @users = User.all
  end
  
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
    # correct_userが先に実行されるため、@user定義なし
  end
  
  def update
    # correct_userが先に実行されるため、@user定義なし
    if @user.update_attributes(user_params)
      flash[:success] = "更新しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # beforeアクション
    
    # ログイン済みユーザーか確認
    def logged_in_user
      #if not logged_in? 以下と同義
      unless logged_in?
        store_location
        flash[:warning] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    # 正しいユーザーか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to (root_url) unless current_user?(@user)  #current_user?()はSessionsHelperで定義
    end
end
