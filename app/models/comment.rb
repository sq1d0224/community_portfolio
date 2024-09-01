# app/models/comment.rb
class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :content, presence: true, length: { maximum: 1000 }
end

# app/models/post.rb
class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :user

  # 他の関連付けやバリデーション
end

# app/models/user.rb
class User < ApplicationRecord
  has_many :comments, dependent: :destroy

  # 他の関連付けやバリデーション
end
