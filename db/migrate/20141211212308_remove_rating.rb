class RemoveRating < ActiveRecord::Migration
  def change
    remove_column :answers, :rating
  end
end
