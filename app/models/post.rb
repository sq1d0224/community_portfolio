class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :user
  has_one_attached :image
  belongs_to :community, optional: true  # コミュニティがない投稿も可能にするため `optional: true`

  # バリデーション
  validates :title, presence: true, length: { maximum: 50 }, unless: :in_community?
  validates :description, presence: true, length: { maximum: 3000 }, unless: :in_community?
  validates :description, presence: true, length: { maximum: 1000 }, if: :in_community?
  
  # コミュニティ内かどうかを判定するメソッド
  def in_community?
    community.present?
  end

  # 画像表示メソッド
  def display_image(size = [300, 300])
    image.variant(resize_to_limit: size).processed
  end
end
