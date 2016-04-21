class AddTypeToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :scope, :string
  end
end
