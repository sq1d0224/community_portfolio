class Users::RegistrationsController < Devise::RegistrationsController
  def create
    
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

    # ユーザー登録を試みる
    if resource.save
      # ユーザーが保存された場合の処理
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
      # エラーメッセージをflashに設定
      flash[:alert] = resource.errors.full_messages.join(', ')
      
      # パスワードエラーの処理
      clean_up_passwords resource
      set_minimum_password_length
      
      # フォームを再表示
      render :new
    end
  end

  protected

  # 新規登録後にリダイレクトするパスを指定するメソッド
  def after_sign_up_path_for(resource)
    user_path(resource) # サインアップ後にプロフィールページにリダイレクト
  end

  # アカウントが非アクティブ状態の場合でもプロフィールページにリダイレクト
  def after_inactive_sign_up_path_for(resource)
    user_path(resource) # 非アクティブでもプロフィールページにリダイレクト
  end
end
