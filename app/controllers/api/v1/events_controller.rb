class API::V1::EventsController < ApplicationController
	load_and_authorize_resource :context => :admin, :class => false
	before_action :authenticate_token!
	before_filter :load_permissions 
	before_action :log_call
	after_action :end_api_session
end
