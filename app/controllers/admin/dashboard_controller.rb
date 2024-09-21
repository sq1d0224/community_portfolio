class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    # 管理者用ダッシュボードの処理
  end
  
end
