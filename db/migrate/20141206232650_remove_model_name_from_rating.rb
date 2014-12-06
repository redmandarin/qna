class RemoveModelNameFromRating < ActiveRecord::Migration
  def change
    remove_column :ratings, :model_id
    remove_column :ratings, :model_name
    add_column :ratings, :user_id, :integer
    add_column :ratings, :question_id, :integer
    add_column :ratings, :answer_id, :integer
  end
end
