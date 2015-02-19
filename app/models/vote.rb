class Vote < ActiveRecord::Base
  include Ratingable
  belongs_to :user
  belongs_to :voteable, polymorphic: true
  
  validates :user_id, :value, :voteable_id, :voteable_type, presence: true
  validates_inclusion_of :value, in: [1, -1]
  validates_uniqueness_of :user_id, scope: [:voteable_id, :voteable_type]

  after_save :calculate_reputation, if: :value_changed?

  private

  def calculate_reputation
    Ratingable.vote(self)
  end
end
