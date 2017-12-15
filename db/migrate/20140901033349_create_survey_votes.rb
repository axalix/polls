class CreateSurveyVotes < ActiveRecord::Migration
  def change
    create_table :survey_votes do |t|
      t.timestamps
    end
  end
end
