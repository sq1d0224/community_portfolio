class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  # バリデーション
  validates :title, presence: true
  validates :description, presence: true
  
  def display_image
    image.variant(resize_to_limit: [300, 300]).processed
  end
  
end

