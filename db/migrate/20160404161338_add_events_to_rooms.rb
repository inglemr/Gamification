class AddEventsToRooms < ActiveRecord::Migration
  def change
    create_table :events_rooms do |t|
      t.belongs_to :event, index: true
      t.belongs_to :room, index: true
      t.timestamps null: false
    end
    remove_column(:events, :room_numbers, :array)
    remove_column(:events, :attendance, :integer)
    remove_column(:users, :events_attended, :integer)
    remove_column(:users, :api_token, :string)
    remove_column(:users, :host_pin, :integer)
    drop_table :kiosks
  end
end
