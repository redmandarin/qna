class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :questions, through: :taggings
  
  validates :name, presence: true
  validates :name, uniqueness: true
end
