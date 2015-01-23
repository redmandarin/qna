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
  has_one :rating, as: :rateable

  # validates :name, presence: true

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first

    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user.skip_confirmation! if auth.provider == 'facebook'
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.send_confirmation_instructions
      user.create_authorization(auth)
    end

    user
  end

  def create_authorization(auth) 
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
