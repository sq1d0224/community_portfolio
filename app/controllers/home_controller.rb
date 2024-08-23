class HomeController < ApplicationController
  def index
    @user = User.new
    @resource_name = :user
    @devise_mapping = Devise.mappings[:user]
  end
end
