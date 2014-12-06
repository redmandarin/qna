class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :body
      t.integer :user_id
      t.integer :question_id
      t.integer :rating

      t.timestamps
    end
  end
end
