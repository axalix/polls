class RenameUploadIdInSurveyEntities < ActiveRecord::Migration
  def change
    rename_column :survey_entities, :upload_id, :image_id
  end
end
