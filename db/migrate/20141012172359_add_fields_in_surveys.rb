class AddFieldsInSurveys < ActiveRecord::Migration
  def change
    remove_column :surveys, :enabled_for_community, :boolean
    add_column :surveys, :publicity_status, :string, limit: 255, null: false, default: 'private'
    add_column :surveys, :public_votes_limit, :integer, default: 0
    add_column :surveys, :public_votes_done,  :integer, default: 0

  end
end
