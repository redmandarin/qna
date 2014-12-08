class AddPolimorphicAssociation < ActiveRecord::Migration
  def change
    remove_column :comments, :question_id
    add_column :comments, :commentable_id, :integer
    add_column :comments, :commentable_type, :string
    remove_column :ratings, :user_id
    remove_column :ratings, :question_id
    remove_column :ratings, :answer_id
    add_column :ratings, :rateable_id, :integer
    add_column :ratings, :rateable_type, :string
  end
end
