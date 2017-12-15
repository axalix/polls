class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :name,          null: false
      t.string :file_name,     null: false
      t.string :content_type,  null: false
      t.string :size,          null: false
      t.string :width
      t.string :height
      t.string :status,        null: false, default: "active"

      t.timestamps
    end
  end
end
