class Community < ApplicationRecord
  has_one_attached :image # 画像をActiveStorageで管理
  belongs_to :user # コミュニティの作成者
  has_many :memberships # コミュニティへの参加者を管理する中間テーブル（後述）
  has_many :users, through: :memberships # コミュニティに参加しているユーザー
  has_many :posts, dependent: :destroy  # コミュニティが削除されたら関連する投稿も削除

  # コミュニティ名の必須と文字数制限（30文字以内）
  validates :title, presence: true, length: { maximum: 30 }
  # 説明の必須と文字数制限（10000文字以内）
  validates :description, presence: true, length: { maximum: 10000 }
  # カテゴリの必須
  validates :category, presence: true
  # 画像の必須
  validates :image, presence: true

  private

  # コミュニティ作成者をメンバーとして自動追加するメソッド
  def add_owner_to_members
    memberships.create(user: user)
  end

end
