# app/controllers/admin/base_controller.rb
class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!  # 管理者認証

  private

  def authenticate_admin!
    unless current_admin  # current_admin で管理者かどうか確認
      redirect_to new_admin_session_path
    end
  end
end
