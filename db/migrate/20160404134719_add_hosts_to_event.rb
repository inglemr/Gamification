class AddHostsToEvent < ActiveRecord::Migration
  def change
    create_table :host_events do |t|
      t.references :hosted_event
      t.references :host
      t.timestamps null: false
    end
  end
end
