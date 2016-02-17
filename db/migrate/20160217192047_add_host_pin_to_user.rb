class AddHostPinToUser < ActiveRecord::Migration
  def change
  	add_column(:users, :host_pin, :integer)
  end
end
