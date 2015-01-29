class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_email, :parent_id, :parent_name, :created_at, :updated_at

  def user_email
    User.find(object.user_id).email
  end

  def parent_id
    object.commentable_id
  end

  def parent_name
    object.commentable_type.downcase.pluralize
  end

end
