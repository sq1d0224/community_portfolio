class User < ApplicationRecord
  # Deviseのモジュール設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :authentication_keys => [:login]


  has_many :posts, dependent: :destroy
  
  # Active Storageによるプロフィール画像の設定
  has_one_attached :profile_image
  
  # 年齢を計算するメソッド
  def age
    return unless birthdate

    now = Time.now.utc.to_date
    now.year - birthdate.year - (birthdate.to_date.change(year: now.year) > now ? 1 : 0)
  end
  
  # 仮想属性loginを追加
  attr_writer :login

  # ユーザーネームかメールアドレスのどちらでもログインできるようにする
  def login
    @login || self.username || self.email
  end

  # ログインの認証条件をオーバーライド
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end

  # ユーザーネームのバリデーション
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  
  # バリデーションの追加
  validates :bio, length: { maximum: 300 }, allow_blank: true

end
