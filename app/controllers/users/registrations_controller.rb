# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  # ユーザー登録のカスタマイズ
  # ユーザーが新規登録した際に呼び出されるメソッド
  # Deviseが提供する標準の動作を上書きしています
  def create
    # ユーザーネームやメールが空の場合のチェック
    if params[:user][:username].blank?
      flash[:alert] = I18n.t('devise.failure.user.blank_username')
      redirect_to new_user_registration_path and return
    elsif params[:user][:email].blank?
      flash[:alert] = I18n.t('devise.failure.user.blank_email')
      redirect_to new_user_registration_path and return
    elsif params[:user][:password].blank?
      flash[:alert] = I18n.t('devise.failure.user.blank_password')
      redirect_to new_user_registration_path and return
    end

    # Deviseの標準の処理を継続
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?

    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      # resource.errors.full_messagesをflashにセット
      flash[:alert] = resource.errors.full_messages.join(', ')
      clean_up_passwords resource
      set_minimum_password_length
      render :new
    end
  end

  protected

  # 新規登録後にリダイレクトするパスを指定するメソッド
  # 通常、Deviseでは `root_path` などにリダイレクトするが、ここではユーザープロフィールページへリダイレクト
  # ログインしたユーザーのプロフィールページ（`user_path(current_user)`）に遷移
  def after_sign_up_path_for(resource)
    user_path(current_user) # サインアップ後にプロフィールページにリダイレクト
  end

  # アカウントが非アクティブ状態の場合（例: メール確認待ちなど）でもプロフィールページにリダイレクト
  # `current_user` はまだアクティブでなくても存在するため、これを使ってリダイレクト
  def after_inactive_sign_up_path_for(resource)
    user_path(current_user) # 非アクティブでもプロフィールページにリダイレクト
  end
end
