class Users::SessionsController < Devise::SessionsController
  def create
    if params[:user][:login].blank?
      flash[:alert] = I18n.t('devise.failure.user.blank_username_or_email')
      redirect_to new_user_session_path and return
    elsif params[:user][:password].blank?
      flash[:alert] = I18n.t('devise.failure.user.blank_password')
      redirect_to new_user_session_path and return
    end

    super
  end
end
