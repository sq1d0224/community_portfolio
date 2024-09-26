# app/controllers/admin/base_controller.rb
class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!  # 管理者認証

  private

  def authenticate_admin!
    unless current_user&.admin? # 管理者かどうかを確認
      redirect_to root_path
    end
  end
end
