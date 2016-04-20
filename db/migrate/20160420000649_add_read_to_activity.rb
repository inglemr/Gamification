class AddReadToActivity < ActiveRecord::Migration
  def change
    change_table :activities do |t|
      t.boolean :read, :default => false
    end
  end
end
