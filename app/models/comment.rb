class Comment < ActiveRecord::Base
  include Authority
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  validates :body, presence: true
end
