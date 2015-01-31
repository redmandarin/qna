class RemoveValueFromVote < ActiveRecord::Migration
  def change
    remove_column :votes, :value
  end
end
