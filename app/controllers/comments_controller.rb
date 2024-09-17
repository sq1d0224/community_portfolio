class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :restrict_guest_user, only: [:create, :destroy]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      # コメントが保存された場合
      redirect_to post_path(@post), notice: 'コメントが追加されました。'
    else
      # コメントの保存に失敗した場合、既存のコメントを再取得する
      @comments = @post.comments.order(created_at: :asc) # コメントが `nil` にならないように
      @comments_count = @comments.size
      flash.now[:alert] = "コメントを入力してください。"
      render 'posts/show'
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      redirect_to post_path(@post), notice: 'コメントが削除されました。'
    else
      redirect_to post_path(@post)
    end
  end

  private
  
  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
  
  def restrict_guest_user
    if guest_user?
      redirect_to new_user_session_path, alert: '新規登録または、ログインしてください。'
    end
  end
  
end
