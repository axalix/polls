class AddNameBioBirthdateGenderInUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, limit: 127
    add_column :users, :bio, :text
    add_column :users, :birth_date, :datetime
    add_column :users, :gender, :string
  end
end
