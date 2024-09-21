# app/controllers/admin/communities_controller.rb
class Admin::CommunitiesController < ApplicationController
  before_action :authenticate_admin!  # 管理者認証
  before_action :set_community, only: [:show, :edit, :update, :destroy]

  def index
    # コミュニティを新しく作成された順に取得
    if params[:search].present?
      @communities = Community.where("title LIKE ?", "%#{params[:search]}%")
                              .order(created_at: :desc)
                              .page(params[:page])
                              .per(10)
    else
      @communities = Community.order(created_at: :desc)
                              .page(params[:page])
                              .per(10)
    end
  end

  def show

    if params[:search].present?
      @paginated_posts = @community.posts.where("description LIKE ?", "%#{params[:search]}%")
                                         .order(created_at: :desc)
                                         .page(params[:page])
                                         .per(10)
    else
      @paginated_posts = @community.posts.order(created_at: :desc).page(params[:page]).per(10)
    end
  end

  def edit
    # 編集フォームを表示
  end

  def update
    if @community.update(community_params)
      redirect_to admin_community_path(@community)
    else
      render :edit
    end
  end


  def destroy
    if @community.destroy
      redirect_to admin_communities_path
    else
      redirect_to admin_community_path(@community)
    end
  end


  private

  def set_community
    @community = Community.find(params[:id])
  end

  def community_params
    params.require(:community).permit(:title, :description, :category, :image)
  end

end
