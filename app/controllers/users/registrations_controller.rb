# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  
  class Users::RegistrationsController < Devise::RegistrationsController
  def create
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
      clean_up_passwords resource
      set_minimum_password_length
      # 失敗した場合に /users/sign_up にリダイレクト
      redirect_to new_user_registration_path
    end
  end
end

  
  protected

  # 新規登録後にユーザーのプロフィールページにリダイレクトする
  def after_sign_up_path_for(resource)
    user_profile_path(resource)
  end

  # 確認が必要な場合（メール確認など）、同様にプロフィールページへリダイレクト
  def after_inactive_sign_up_path_for(resource)
    user_profile_path(resource)
  end
end
