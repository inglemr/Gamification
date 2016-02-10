class CreateTableKiosk < ActiveRecord::Migration
  def change
    create_table :kiosks do |t|
    	t.string :location
    	t.string :token
    	t.integer :location_id
    end
    add_index :kiosks, :location_id
  end
end
