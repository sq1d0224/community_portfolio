class User < ApplicationRecord
  # Deviseのモジュール設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [:login]

  # アソシエーション
  has_many :posts, dependent: :destroy   # ユーザーが削除されたら、関連する投稿も削除
  has_one_attached :profile_image        # Active Storageによるプロフィール画像

  # 年齢を計算するメソッド
  def age
    return unless birthdate

    now = Time.now.utc.to_date
    now.year - birthdate.year - (birthdate.to_date.change(year: now.year) > now ? 1 : 0)
  end

  # 仮想属性 `login` を追加
  attr_writer :login
  
  # 仮想属性 :remove_profile_image を追加
  attr_accessor :remove_profile_image
  
  # 保存前に画像を削除する
  before_save :purge_profile_image, if: -> { remove_profile_image == '1' }

  # ユーザーネームまたはメールアドレスでログインできるようにする
  def login
    @login || self.username || self.email
  end

  # ログインの認証条件をオーバーライド
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h)
        .where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }])
        .first
    else
      where(conditions.to_h).first
    end
  end

  # バリデーション
  validates :username, presence: true, uniqueness: { case_sensitive: false }  # ユーザーネームは必須で一意
  validates :email, presence: true, uniqueness: { case_sensitive: false }     # メールアドレスも必須で一意
  validates :bio, length: { maximum: 10000 }, allow_blank: true                 # 自己紹介は任意だが10000文字以内
  # パスワードのバリデーション
  validates :password, length: { minimum: 8 }, if: -> { password.present? }
  
  private

  def purge_profile_image
    profile_image.purge
  end

end
