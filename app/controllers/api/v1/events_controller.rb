class API::V1::EventsController < ApplicationController
	load_and_authorize_resource :context => :admin, :class => false
	before_filter :load_permissions 
end
