class ChangeIndexes < ActiveRecord::Migration
  def change
    remove_index :attachments, :attachmentable_id
    remove_index :attachments, :attachmentable_type
    add_index :attachments, [:attachmentable_id, :attachmentable_type]
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
