class Question < ActiveRecord::Base
  include Authority

  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_one :rating, as: :rateable, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user_id, presence: true

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

end
