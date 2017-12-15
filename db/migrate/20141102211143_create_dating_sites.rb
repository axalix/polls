class CreateDatingSites < ActiveRecord::Migration
  def change
    create_table :dating_sites do |t|
      t.string    :code, null: false, limit: 255
      t.string    :name, null: false, limit: 128
      t.string    :url, null: false, limit: 255
      t.string    :image_url, null: false, limit: 255
      t.text      :keywords, default: '' #- An array of keywords or phrases for us to search on
      t.string    :status, null: false, default: "active"
    end
  end
end