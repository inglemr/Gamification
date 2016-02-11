class ChangeColumnLocationInEvents < ActiveRecord::Migration
  def change
  	remove_column(:events, :location)
  	add_column(:events, :location_id, :integer)
  	add_index :events, :location_id
  end
end
