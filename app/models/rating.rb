class Rating < ActiveRecord::Base
  validates :model_id, :model_name, presence: true

  belongs_to :rateable, polymorphic: true
  has_many :votes

end
