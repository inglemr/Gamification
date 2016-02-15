class UpdateIndexOnKiosks < ActiveRecord::Migration
	def up
	  sql = 'DROP INDEX index_kiosks_on_email'
	  sql << ' ON kiosks' if Rails.env == 'production' # Heroku pg
	  ActiveRecord::Base.connection.execute(sql)
	end
end
