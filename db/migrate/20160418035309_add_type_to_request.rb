class AddTypeToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :request_type, :string
  end
end
