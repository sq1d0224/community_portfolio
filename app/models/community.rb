class Community < ApplicationRecord
  has_one_attached :image # 画像をActiveStorageで管理
  validates :title, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 10000 }
end
