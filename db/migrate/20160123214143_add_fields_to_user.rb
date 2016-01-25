class AddFieldsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :username, :string
  	add_column :users, :gsw_pin, :string
  	add_column :users, :gsw_id, :string
  	add_column :users, :points, :integer
  	add_column :users, :events_attended, :integer
  end
end
