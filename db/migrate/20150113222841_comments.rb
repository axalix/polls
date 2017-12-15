class Comments < ActiveRecord::Migration
  def change
    create_table    :comments do |t|
      t.integer     :user_id, null: false
      t.references  :commented_obj, polymorphic: true, null: true, index: true
      t.text        :text, null: false
      t.string      :status,  null: false, default: "active"
      t.integer     :num_votes, default: 0
      t.integer     :total_score, default: 0

      t.timestamps
    end

    add_foreign_key :comments, :users
    add_index :comments, :user_id
  end
end
