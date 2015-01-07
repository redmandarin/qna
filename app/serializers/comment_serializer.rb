class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_name, :parent_id

  def user_name
    User.find(object.user_id).name
  end

  def parent_id
    object.commentable_id
  end

end
