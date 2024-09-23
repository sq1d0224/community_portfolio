class Admin::CommentsController < Admin::BaseController
  before_action :authenticate_admin!  # 管理者認証
  before_action :set_comment, only: [:destroy]  # destroy のみで set_comment を実行

  # コメント一覧と検索機能
  def index
    if params[:search].present?
      @comments = Comment.where("content LIKE ?", "%#{params[:search]}%")
                         .order(created_at: :desc)
                         .page(params[:page])
                         .per(10) # ページネーション
    else
      @comments = Comment.order(created_at: :desc)
                         .page(params[:page])
                         .per(10)
    end
  end

  def destroy
    # コメントに紐づく投稿がある場合は @post を取得
    @post = @comment.post if @comment.respond_to?(:post)

    @comment.destroy

    # リダイレクト先を条件に応じて変更
    if params[:redirect_url].present?
      redirect_to params[:redirect_url]
    elsif @post
      redirect_to admin_post_path(@post)
    else
      redirect_to admin_comments_path
    end
  end

  private

  def set_comment
    # コメントを直接取得する
    @comment = Comment.find(params[:id])
  end
end
