class AddIndexToVotes < ActiveRecord::Migration
  def change
    remove_column :votes, :rateable_id
    remove_column :votes, :rateable_type
    add_column :votes, :voteable_id, :integer
    add_column :votes, :voteable_type, :string
    add_index :votes, [:voteable_id, :voteable_type]
    add_index :votes, :user_id
  end
end
