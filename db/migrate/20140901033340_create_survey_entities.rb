class CreateSurveyEntities < ActiveRecord::Migration
  def change
    create_table :survey_entities do |t|
      t.integer :survey_id
      t.integer :upload_id
      t.text    :text
      t.integer :num_votes, default: 0

      t.timestamps
    end

    add_foreign_key :survey_entities, :uploads
    add_foreign_key :survey_entities, :surveys
  end
end
