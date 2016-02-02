class API::V1::EventsController < API::BaseController
	load_and_authorize_resource
	before_filter :load_permissions 
private
	def self.permission
	  return "API::Events"
	end

end
