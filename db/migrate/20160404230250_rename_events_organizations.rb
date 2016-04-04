class RenameEventsOrganizations < ActiveRecord::Migration
  def change
    remove_column :events, :department, :string
    add_column :events, :organization_id, :integer
  end
end
