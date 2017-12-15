class AddUserIdToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :user_id, :integer, null: false

    add_foreign_key :surveys, :users
    add_index :surveys, :user_id
  end
end
