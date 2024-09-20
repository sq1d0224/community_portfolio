class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # すでにログインしている場合にdeviseのフラッシュメッセージをクリアする
  before_action :clear_devise_flash, if: -> { user_signed_in? }


  # ビューでも使えるようにする
  helper_method :guest_user?

  # ゲストユーザーかどうかを判定するメソッド
  def guest_user?
    current_user && current_user.email == 'guest@example.com'
  end

  # ゲストユーザーのアクセスを制限するメソッド
  def restrict_guest_user
    if guest_user?
      redirect_to new_user_session_path, alert: 'ゲストユーザーではこの操作を行えません。'
    end
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email])
  end

  def after_sign_in_path_for(resource)
    if resource.email == 'guest@example.com'
      guest_dashboard_path # ゲストユーザーは特定のページへリダイレクト
    else
      user_path(resource) # 通常ユーザーはプロフィールページにリダイレクト
    end
  end


  private

  def clear_devise_flash
    if flash[:alert] == I18n.t('devise.failure.already_authenticated')
      flash.delete(:alert)
    end
  end

end
