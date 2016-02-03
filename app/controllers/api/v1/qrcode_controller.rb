class API::V1::QrcodeController < API::BaseController
	load_and_authorize_resource :class => false
	before_filter :load_permissions 
end
