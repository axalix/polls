class CreateTinderProfiles < ActiveRecord::Migration
  def change
    create_table :tinder_profiles do |t|
      t.string    :uid, null: false, limit: 255
      t.string    :name, null: false, limit: 127
      t.string    :bio, limit: 1023
      t.datetime  :birth_date
      t.integer   :gender
      t.string    :photo, limit: 255
      t.float     :latitude, null: false
      t.float     :longitude, null: false
      t.float     :distance, null: false
      t.text      :json, null: false

      t.timestamps
    end

    add_index :tinder_profiles, :uid, unique: true
  end
end

