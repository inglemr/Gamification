class AddRecurringToEvent < ActiveRecord::Migration
  def change
  	add_column(:events, :recurring_id, :integer)
  end
end
