class API::V1::QrcodeController < ApplicationController
	before_action :authenticate_token!
	load_and_authorize_resource :context => :admin, :class => false
	before_filter :load_permissions 
	before_action :log_call
end
