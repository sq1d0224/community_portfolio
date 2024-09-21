# app/controllers/admin/sessions_controller.rb
class Admin::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

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

end
