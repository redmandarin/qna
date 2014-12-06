class Vote < ActiveRecord::Base
  validates :user_id, :rating_id, :value, presence: true

  belongs_to :user
  belongs_to :rating
end
