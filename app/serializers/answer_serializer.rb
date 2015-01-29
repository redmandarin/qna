class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_email, :parent_id, :created_at, :updated_at
  has_many :attachments

  def user_email
    User.find(object.user_id).email
  end

  def parent_id
    object.question.id
  end

  def files
    object.attachments.collect { |attachment| {filename: attachment.file.file.filename, url: attachment.file.url} }
  end
end
