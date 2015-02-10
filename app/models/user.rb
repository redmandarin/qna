class User < ActiveRecord::Base
  include Authority
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :authorizations
  has_many :votes
  has_many :questions
  has_many :answers
  has_many :comments

  before_create :skip_confirmation

  validates :rating, presence: true

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first

    if user
      user.create_authorization(auth)
      user.send_confirmation_instructions
    elsif email
      password = Devise.friendly_token[0, 20]
      user = User.create(email: email, password: password, password_confirmation: password)
      user.create_authorization(auth)
      user.no_need_to_confirm(auth)
    else
      user = User.new
    end

    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def no_need_to_confirm(auth)
    p = auth.provider
    if p == "facebook" || p == 'github' || p == 'google'
      self.skip_confirmation!
    end
  end

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.delay.digest(user)
    end
  end

  private

  def skip_confirmation

  end
end
