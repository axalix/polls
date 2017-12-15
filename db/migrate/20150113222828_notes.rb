class Notes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :user_id, null: false
      t.string  :kind,  null: false
      t.string  :source,  null: false
      t.text    :text, null: false
      t.string  :status,  null: false, default: "active"

      t.timestamps
    end

    add_foreign_key :notes, :users
    add_index :notes, :user_id
  end
end
