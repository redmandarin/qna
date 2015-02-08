class UserRatingToNotNull < ActiveRecord::Migration
  def change
    remove_column :users, :rating
    add_column :users, :rating, :integer, default: 0, null: false
  end
end
