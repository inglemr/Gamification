class AddKioskNameToKiosks < ActiveRecord::Migration
  def change
  	add_column(:kiosks, :kiosk_name, :string)
  end
end
