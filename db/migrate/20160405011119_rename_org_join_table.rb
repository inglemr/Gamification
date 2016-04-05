class RenameOrgJoinTable < ActiveRecord::Migration
  def change
    rename_table :users_organizations, :organizations_users
  end
end
