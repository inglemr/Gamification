class RenameUserColumnInEvent < ActiveRecord::Migration
  def change
  	rename_column :events, :user_id, :created_by
  	add_column :events, :updated_by, :integer
  end
end
