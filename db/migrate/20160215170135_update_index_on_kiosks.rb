class UpdateIndexOnKiosks < ActiveRecord::Migration
	def up
	  sql = 'DROP INDEX index_kiosks_on_email'
	  ActiveRecord::Base.connection.execute(sql)
	end
end
