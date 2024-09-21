class Admin::CommentsController < Admin::BaseController
  before_action :authenticate_admin!  # 管理者認証
  before_action :set_post
  before_action :set_comment, only: [:destroy]

  def destroy
    @comment.destroy
    redirect_to admin_post_path(@post)
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end
end