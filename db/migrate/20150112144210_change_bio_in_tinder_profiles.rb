class ChangeBioInTinderProfiles < ActiveRecord::Migration
  def change
    change_column :tinder_profiles, :bio, :text
  end
end
