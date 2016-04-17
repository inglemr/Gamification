class AddSlugToModels < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string
    add_index :users, :slug
    add_column :events, :slug, :string
    add_index :events, :slug
    add_column :organizations, :slug, :string
    add_index :organizations, :slug
    add_column :roles, :slug, :string
    add_index :roles, :slug
    add_column :permissions, :slug, :string
    add_index :permissions, :slug
    add_column :locations, :slug, :string
    add_index :locations, :slug
    add_column :rooms, :slug, :string
    add_index :rooms, :slug
  end
end
