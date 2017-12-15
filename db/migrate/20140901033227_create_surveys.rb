class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string    :type, null: false
      t.string    :status, null: false
      t.string    :url_hash, limit: 128
      t.datetime  :url_hash_expires_at
      t.integer   :num_votes, default: 0
      t.boolean   :enabled_for_community, default: false

      t.timestamps
    end

    add_index :surveys, :url_hash, unique: true
  end
end
