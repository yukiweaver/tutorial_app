module SessionsHelper
  
  # 引数に渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # 現在ログイン中のユーザーを返す (ただし、いる場合のみ)
  def current_user  
    if session[:user_id]
    #   if @current_user.nil?  と下記同義
    #      @current_user = User.find_by(id: session[:user_id])
    #   else
    #       @current_user
    #   end
    # @current_user = @current_user || User.find_by(id: session[:user_id]) と下記同義
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  
  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end
  
  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end
  
  def redirect_back_or(default)
    redirect_to(session[:fowarding_url] || default)
    session.delete(:fowarding_url)
  end
  
  # アクセスしようとしたURLを記憶
  # getリクエストのみ記憶
  def store_location
    session[:fowarding_url] = request.original_url if request.get?
  end
  
  
end
