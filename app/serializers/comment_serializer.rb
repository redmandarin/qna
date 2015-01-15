class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_name, :parent_id, :parent_name

  def user_name
    User.find(object.user_id).name
  end

  def parent_id
    object.commentable_id
  end

  def parent_name
    object.commentable_type.downcase.pluralize
  end

end
