class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  # 新規登録ページ
  def new
    @user = User.new
  end
  
  # 勤怠表示ページ
  def show
    @user = User.find(params[:id])
    
    if params[:first_day].nil?
      @first_day = Date.today.beginning_of_month
    else
      @first_day = Date.parse(params[:first_day])
    end
    
    @last_day = @first_day.end_of_month
    
    (@first_day..@last_day).each do |day|
      unless @user.attendances.any? {|attendance| attendance.worked_on == day}
        record = @user.attendances.build(worked_on: day)
        record.save
      end
    end
    @dates = @user.attendances.where('worked_on >= ? and worked_on <= ?', @first_day, @last_day).order('worked_on')
    @work_sum = @dates.where.not(started_at: !nil).count
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
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "削除しました。"
    redirect_to users_url
  end
  
  # 基本情報編集ページ
  def edit_basic_info
    @user = User.find(params[:id])
  end
  
  # 基本情報更新
  def update_basic_info
    @user = User.find(params[:id])
    if @user.update_attributes(basic_info_params)
      flash[:success] = "基本情報を更新しました。"
      redirect_to @user
    else
      render 'edit_basic_info'
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:basic_time, :work_time)
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
    
    # 管理者かどうか確認
    def admin_user
      redirect_to (root_url) unless current_user.admin?
    end
end
