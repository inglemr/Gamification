class AddRecordsToUsers < ActiveRecord::Migration
  def change
  	enable_extension 'hstore'
  	add_column :users, :user_type, :string
  	add_column :users, :last_semester, :hstore
  	add_column :users, :current_semester, :hstore
  	add_column :users, :class_type, :string
  	add_column :users, :name, :string
  end
end
