class Admin < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 仮想属性 `login` を追加
  attr_accessor :login

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  # ユーザーネームまたはメールアドレスでログインできるようにする
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      Rails.logger.debug "Searching for admin by login: #{login}"
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end
  
end
