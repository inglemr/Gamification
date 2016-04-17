class CreateOrgRolesAndPerm < ActiveRecord::Migration
  def change
    create_table :org_roles do |t|
      t.integer :user_id
      t.integer :org_id
      t.string :name
      t.text :description
      t.text :permissions, array: true, default: []
    end
  end
end
