class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :value
      t.string :model_name
      t.integer :model_id

      t.timestamps
    end
  end
end
