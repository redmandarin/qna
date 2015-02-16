class Question < ActiveRecord::Base
  include Authority
  include Ratingable

  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, as: :voteable, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :attachments, as: :attachmentable
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  belongs_to :user

  validates :title, :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true

  after_create :update_rating

  def self.tagged_with(name)
    Tag.where(name: name).first.questions
  end

  def tag_list=(tag_list)
    self.tags = tag_list.split(',').map do |tag_name|
      Tag.where(name: tag_name.strip).first_or_create!
    end
  end

  def tag_list
    self.tags.map(&:name).join(', ')
  end

  protected

  def update_rating
    self.delay.calculate_rating
  end
end
