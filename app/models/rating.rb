class Rating < ActiveRecord::Base
  belongs_to :rateable, polymorphic: true
  has_many :votes

  validates :model_id, :model_name, presence: true
end
