class Uploads < ActiveRecord::Migration
  def change
    remove_foreign_key :survey_entities, :uploads
    drop_table :uploads

    create_table :uploads do |t|
      t.string      :name
      t.attachment  :resource
      t.references  :parent, polymorphic: true, null: true, index: true
      t.string :width
      t.string :height
      t.string :status, null: false, default: "active"

      t.timestamps
    end

    add_foreign_key :survey_entities, :uploads
    add_index :survey_entities, :upload_id
  end
end
