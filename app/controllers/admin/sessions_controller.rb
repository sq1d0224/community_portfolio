# app/controllers/admin/sessions_controller.rb
class Admin::SessionsController < Devise::SessionsController
  
  
  protected
  # ログイン後のリダイレクト先を指定
  def after_sign_in_path_for(resource)
    admin_root_path  # ログイン後に管理者用ダッシュボードへリダイレクト
  end

  # ログアウト後のリダイレクト先を指定
  def after_sign_out_path_for(resource_or_scope)
    new_admin_session_path  # ログアウト後に管理者ログインページにリダイレクト
  end
end
