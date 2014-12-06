class SetDefaultValueToZeroInRating < ActiveRecord::Migration
  def change
    remove_column :ratings, :value
    add_column :ratings, :value, :integer, default: 0
  end
end
