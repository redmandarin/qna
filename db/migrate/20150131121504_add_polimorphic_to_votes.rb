class AddPolimorphicToVotes < ActiveRecord::Migration
  def change
    remove_column :votes, :rating_id
    add_column :votes, :rateable_id, :integer
    add_column :votes, :rateable_type, :string
    add_column :votes, :value, :integer
    add_column :users, :rating, :integer, default: 0
    add_column :questions, :rating, :integer, default: 0
    add_column :answers, :rating, :integer, default: 0
  end
end
