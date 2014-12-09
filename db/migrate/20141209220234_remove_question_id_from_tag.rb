class RemoveQuestionIdFromTag < ActiveRecord::Migration
  def change
    remove_column :tags, :question_id
  end
end
