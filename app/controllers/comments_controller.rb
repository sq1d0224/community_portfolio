# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to post_path(@post), notice: 'コメントが追加されました。'
    else
      redirect_to post_path(@post), alert: 'コメントを追加できませんでした。'
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      redirect_to post_path(@post), notice: 'コメントが削除されました。'
    else
      redirect_to post_path(@post), alert: 'コメントを削除できませんでした。'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
