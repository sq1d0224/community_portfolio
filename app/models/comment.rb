# app/models/comment.rb
class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :content, presence: true, length: { maximum: 1000 }
end

