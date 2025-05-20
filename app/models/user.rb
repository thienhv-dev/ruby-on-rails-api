class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validates :name, presence: true, length: { maximum: 50 }, allow_blank: false

  has_many :active_follows, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy
  has_many :following, through: :active_follows, source: :followed

  has_many :passive_follows, class_name: 'Follow', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower

  has_many :posts, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    %w[id name email created_at updated_at]
  end
end