class Admin::LogController < ApplicationController
	load_and_authorize_resource :context => :admin
	before_filter :load_permissions 

	def index
		respond_to do |format|
    		format.html
    		format.json { render json: Admin::LogsDatatable.new(view_context) }
  		end
	end

end
