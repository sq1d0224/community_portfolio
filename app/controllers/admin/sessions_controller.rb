# app/controllers/admin/sessions_controller.rb
class Admin::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
  before_action :prevent_access_for_logged_in_users, only: [:new]

  # POST /admin/sign_in
  def create
    super
  end


  protected
  # ログイン後のリダイレクト先を指定
  def after_sign_in_path_for(resource)
    admin_root_path  # ログイン後に管理者用ダッシュボードへリダイレクト
  end

  # ログアウト後のリダイレクト先を指定
  def after_sign_out_path_for(resource_or_scope)
    new_admin_session_path  # ログアウト後、ルートパスへリダイレクト
  end

  private

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password, :remember_me])
  end

  # 一般ユーザーがログインしている場合、/admin/sign_inにアクセスできないようにする
  def prevent_access_for_logged_in_users
    if user_signed_in? && !current_user.admin?
      redirect_to root_path
    end
  end

end
