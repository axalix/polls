class Ratings < ActiveRecord::Migration
  def change
    create_table    :ratings do |t|
      t.integer     :user_id, null: false
      t.references  :rated_obj, polymorphic: true, null: true, index: true
      t.integer     :score, default: 0

      t.timestamps
    end

    add_foreign_key :ratings, :users
    add_index :ratings, :user_id
  end
end
