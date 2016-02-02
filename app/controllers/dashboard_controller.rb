class DashboardController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :class => false
  before_filter :load_permissions
  def index
  	respond_to do |format|
    	format.html
    	format.json { render json: EventsDatatable.new(view_context) }
  	end
  end
  
end
