class AddCreatorToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :created_by, :integer
  end
end
