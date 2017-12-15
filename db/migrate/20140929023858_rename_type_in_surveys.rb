class RenameTypeInSurveys < ActiveRecord::Migration
  def change
    rename_column :surveys, :type, :kind
  end
end
