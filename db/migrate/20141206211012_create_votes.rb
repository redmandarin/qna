class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.integer :rating_id
      t.integer :value

      t.timestamps
    end
  end
end
