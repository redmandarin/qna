class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_name, :parent_id, :files

  def user_name
    User.find(object.user_id).name
  end

  def parent_id
    object.question.id
  end

  def files
    object.attachments.collect { |attachment| {filename: attachment.file.file.filename, url: attachment.file.url} }
  end

end
