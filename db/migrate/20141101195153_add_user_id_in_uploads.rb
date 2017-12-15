class AddUserIdInUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :user_id, :integer

    add_foreign_key :uploads, :users
    add_index :uploads, :user_id
  end
end
