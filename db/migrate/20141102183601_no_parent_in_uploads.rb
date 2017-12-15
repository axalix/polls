class NoParentInUploads < ActiveRecord::Migration
  def change
    remove_reference :uploads, :parent, polymorphic: true, null: true, index: true
    add_column :uploads, :num_refs, :integer, default: 0
  end
end
