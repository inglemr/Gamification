class UserEvents < ActiveRecord::Migration
  def change
  	create_table :user_events do |t|
  		t.references :attended_event
      t.references :attendee
      t.timestamps null: false
    end
  end
end
