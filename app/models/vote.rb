class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :rating
  
  validates :user_id, :rating_id, :value, presence: true
end
