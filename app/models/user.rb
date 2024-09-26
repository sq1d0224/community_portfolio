class User < ApplicationRecord
  # Deviseのモジュール設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [:login]

  has_many :comments, dependent: :destroy

  # アソシエーション
  has_many :posts, dependent: :destroy   # ユーザーが削除されたら、関連する投稿も削除
  has_one_attached :profile_image        # Active Storageによるプロフィール画像

  # アソシエーション
  has_many :memberships
  has_many :communities, through: :memberships # 参加しているコミュニティ
  has_many :owned_communities, class_name: 'Community' # 管理しているコミュニティ
  has_many :joined_communities, through: :memberships, source: :community # 参加しているコミュニティ

  # ユーザーが作成したコミュニティを表す関連付け
  has_many :created_communities, class_name: 'Community', foreign_key: 'user_id', dependent: :destroy

  def self.guest
    # メールアドレスで既存のゲストユーザーを検索
    user = find_by(email: 'guest@example.com')

    # 既存のゲストユーザーがあればそのまま返す
    return user if user.present?

    # ゲストユーザーが存在しない場合のみ新規作成
    create_guest_user
  end

  # ゲストユーザーを新規作成するメソッド
  def self.create_guest_user
    create!(
      email: 'guest@example.com',
      password: SecureRandom.urlsafe_base64,
      username: "ゲストユーザー_#{SecureRandom.hex(5)}" # ユーザーネームをユニークにするためランダム文字列を追加
    ).tap do |user|
      user.profile_image.attach(
        io: File.open(Rails.root.join('app/assets/images/no_image_photo.jpg')),
        filename: 'no_image_photo.jpg'
      )
    end
  end

  # ゲストユーザーかどうかを確認するメソッド
  def guest_user?
    email == 'guest@example.com'
  end

  # ユーザーが特定のコミュニティに参加しているかどうかを確認するメソッド
  def joined_community?(community)
    communities.include?(community)
  end

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

  # 退会済みユーザーかどうかを判定するメソッド
  def deleted?
    self.is_deleted
  end

  # 退会済みなら「退会ユーザー」を返し、そうでない場合は通常のユーザーネームを返す
  def display_name
    deleted? ? '退会ユーザー' : username
  end

  # 退会済みユーザーのプロフィール画像を設定
  def profile_image_or_default
    if self.deleted?
      'no_image_photo.jpg' # 退会済みか画像がない場合、デフォルト画像を使用
    else
      self.profile_image
    end
  end

  # 通知の送信を制御
  def can_receive_notifications?
    !self.deleted?
  end

  def active_for_authentication?
    super && !deleted?
  end

  def inactive_message
    deleted? ? :deleted_account : super
  end

  # 管理者かどうかを判定するメソッド
  def admin?
    self.admin
  end


  # バリデーション
  validates :username, presence: true, uniqueness: { case_sensitive: false }  # ユーザーネームは必須で一意
  validates :email, presence: true, uniqueness: { case_sensitive: false }     # メールアドレスも必須で一意
  validates :bio, length: { maximum: 10000 }, allow_blank: true                 # 自己紹介は任意だが10000文字以内
  # パスワードのバリデーション
  validates :password, length: { minimum: 8 }, if: -> { password.present? }

  scope :active_users, -> { where(is_deleted: false).where.not(email: 'guest@example.com') }

  private

  def purge_profile_image
    if profile_image.attached?
      profile_image.purge # 凍結される前に即時削除
    end
  end

end
