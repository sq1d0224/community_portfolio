class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # すでにログインしている場合にdeviseのフラッシュメッセージをクリアする
  before_action :clear_devise_flash, if: -> { user_signed_in? }

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email])
  end
  
  def after_sign_in_path_for(resource)
    user_path(resource) # ログイン後はトップページにリダイレクト
  end
  

  private

  def clear_devise_flash
    if flash[:alert] == I18n.t('devise.failure.already_authenticated')
      flash.delete(:alert)
    end
  end
end
