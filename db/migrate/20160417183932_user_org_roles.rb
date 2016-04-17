class UserOrgRoles < ActiveRecord::Migration
  def change
    remove_column :org_roles, :user_id, :integer
    create_table :user_org_roles do |t|
      t.integer :user_id
      t.integer :org_role_id
    end
  end
end
