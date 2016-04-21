class AddNotificationSettingToUser < ActiveRecord::Migration
  def change
    add_column :users, :notification_settings, :text
  end
end
