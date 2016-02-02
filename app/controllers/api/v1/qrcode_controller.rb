class API::V1::QrcodeController < API::BaseController
	load_and_authorize_resource
	before_filter :load_permissions 
	private
	def self.permission
	  return "API::Qrcode"
	end

end
