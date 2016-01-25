class CreateUsersEventsSet < ActiveRecord::Migration
  def change
    create_table :users_events_sets do |t|
      t.timestamps
    end

    create_table :users_events_sets_events do |t|
      t.references :users_events_set, :null => false
      t.references :event, :null => false
    end

    add_column :users, :users_events_set_id, :integer

    add_index :users, :users_events_set_id
    add_index :users_events_sets_events, :users_events_set_id, :name => :ix_items_users_events_sets_events
    add_index :users_events_sets_events, :event_id, :name => :ix_events_users_events_sets_events
  end
end
