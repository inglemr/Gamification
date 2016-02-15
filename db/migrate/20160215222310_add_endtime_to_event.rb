class AddEndtimeToEvent < ActiveRecord::Migration
  def change
  	add_column(:events, :end_time, :timestamp)
  end
end
