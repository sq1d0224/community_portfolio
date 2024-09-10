class CommunitiesController < ApplicationController
  def index
    @communities = Community.all
  end

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params)
    if @community.save
      redirect_to communities_path, notice: 'コミュニティが作成されました。'
    else
      render :new
    end
  end

  private

  def community_params
    params.require(:community).permit(:title, :description, :category, :image)
  end
end
