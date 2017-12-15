class AddFieldsInSurveyVotes < ActiveRecord::Migration
  def change
    add_column :survey_votes, :survey_id,         :integer, null: false
    add_column :survey_votes, :survey_entity_id,  :integer, null: false
    add_column :survey_votes, :user_id,           :integer
    add_column :survey_votes, :remote_ip,         :string,  null: false

    add_foreign_key :survey_votes, :surveys
    add_foreign_key :survey_votes, :survey_entities
    add_foreign_key :survey_votes, :users

    add_index :survey_votes, [:survey_id, :user_id], unique: true
    add_index :survey_votes, :survey_id
    add_index :survey_votes, [:survey_id, :survey_entity_id]
    add_index :survey_votes, :user_id
  end
end
