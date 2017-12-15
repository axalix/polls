class Tags < ActiveRecord::Migration
  def change
    create_table    :tags do |t|
      t.integer     :user_id, null: false
      t.references  :tagged_obj, polymorphic: true, null: true, index: true
      t.string      :text, null: false, limit: 255
      t.string      :status,  null: false, default: "active"
      t.integer     :num_votes, default: 0
      t.integer     :total_score, default: 0

      t.timestamps
    end

    add_foreign_key :tags, :users
    add_index :tags, :user_id
  end
end
