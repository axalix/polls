class AddProvidersFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string, limit: 255
    add_column :users, :provider_user_id, :string
  end
end
