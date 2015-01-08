class User < ActiveRecord::Base
  include Authority
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :votes
  has_many :questions
  has_many :answers
  has_many :comments
  has_one :rating, as: :rateable

  validates :name, presence: true
end
