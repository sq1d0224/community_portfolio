class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  # バリデーション
  validates :title, presence: true
  validates :description, presence: true
  
  # 画像表示メソッド
  def display_image
    if image.attached?
      image.variant(resize_to_limit: [300, 300]).processed
    else
      'no_image_photo.jpg' # 画像が添付されていない場合のデフォルト画像
    end
  end
  
end

