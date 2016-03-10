class AddThemeSelectionToUser < ActiveRecord::Migration
  def change
    add_column :users, :theme, :string, default: "smart-style-5"
  end
end
