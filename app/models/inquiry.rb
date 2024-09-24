class Inquiry < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :category, presence: true
  validates :content, presence: true, length: { maximum: 10000 }
end
