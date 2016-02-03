class API::V1::QrcodeController < ApplicationController
	load_and_authorize_resource :context => :admin, :class => false
	before_filter :load_permissions 
end
