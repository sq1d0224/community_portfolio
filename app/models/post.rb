class Post < ApplicationRecord
  
  has_many :comments, dependent: :destroy
  belongs_to :user
  has_one_attached :image

  # バリデーション
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 3000 }
  
  # 画像表示メソッド
  def display_image(size: [300, 300])
    if image.attached?
      image.variant(resize_to_limit: size).processed
    else
      'no_image_photo1.jpg' # 画像が添付されていない場合のデフォルト画像
    end
  end
  
end

