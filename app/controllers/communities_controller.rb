class CommunitiesController < ApplicationController
  before_action :set_community, only: [:show, :edit, :update, :destroy]
  
  def index
    @communities = Community.includes(:user, :users).page(params[:page]).per(10)
  
    if params[:search].present?
      @communities = @communities.where("title LIKE ?", "%#{params[:search]}%")
    end
  end

  def new
    @community = Community.new
  end

  def create
    @community = current_user.communities.new(community_params) # current_userでコミュニティ作成
    if @community.save
      redirect_to communities_path
    else
      render :new
    end
  end
  
  def show
    # @communityはbefore_actionでセットされます
  end

  private
  
  def set_community
    @community = Community.find(params[:id])
  end

  def community_params
    params.require(:community).permit(:title, :description, :category, :image)
  end
end
