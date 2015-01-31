class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :voteable, polymorphic: true
  
  validates :user_id, :value, :voteable_id, :voteable_type, presence: true
  validates_inclusion_of :value, in: [1, -1]
  validates_uniqueness_of :user_id, scope: [:voteable_id, :voteable_type]
end
