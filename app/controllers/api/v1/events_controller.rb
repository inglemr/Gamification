class API::V1::EventsController < ApplicationController
	load_and_authorize_resource
	rescue_from CanCan::AccessDenied do |exception|
    	redirect_to root_url, :alert => exception.message
  end
end
