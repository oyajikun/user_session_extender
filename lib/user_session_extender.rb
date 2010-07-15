# = ユーザセッション拡張プラグイン
# Author:: oyajikun
#
# ユーザセッションで用いる処理を定義する
module UserSessionExtender
  module InstanceMethods
    # = アクセスユーザのセッションモデル取得
    # Author:: oyajikun
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    # = アクセスユーザのユーザモデル取得
    # Author:: oyajikun
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    # = 遷移元URLの記録
    # Author:: oyajikun
    def store_location
      session[:return_to] = request.request_uri
    end

    # = 遷移元URL記録有無によるリダイレクト判定
    # Author:: oyajikun
    #
    # _default_ :: デフォルトのリダイレクトURL
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    # = ログイン状態判定
    # Author:: oyajikun
    #
    # アクセスユーザのモデルクラスを取得していないとき、未ログイン状態とみなし、ログインページへ飛ばす。
    # before_filter に指定して使用する。
    def require_login
      unless current_user
        store_location
        flash[:notice] = t("flash.require.login", :default => "require login")
        redirect_to login_url
        return false
      end
    end

    # = ログアウト状態判定
    # Author:: oyajikun
    #
    # アクセスユーザのモデルクラスを取得しているとき、ログイン状態とみなし、ユーザ詳細ページへ飛ばす。
    # before_filter に指定して使用する。
    def require_logout
      if current_user
        store_location
        flash[:notice] = t("flash.require.logout", :default => "require logout")
        redirect_to user_url
        return false
      end
    end
  end
end

module ActionController
  class Base
    include UserSessionExtender::InstanceMethods
  end
end
