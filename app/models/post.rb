class Post < ApplicationRecord
  
  has_many :comments, dependent: :destroy
  belongs_to :user
  has_one_attached :image

  # バリデーション
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 3000 }
  
  # 画像表示メソッド
  def display_image(size = [300, 300])
    image.variant(resize_to_limit: size).processed
  end
  
end

