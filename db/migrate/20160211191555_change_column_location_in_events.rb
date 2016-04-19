class ChangeColumnLocationInEvents < ActiveRecord::Migration
  def change]
  	add_index :events, :location_id
  end
end
