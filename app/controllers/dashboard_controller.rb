class DashboardController < ApplicationController
  def index
  	respond_to do |format|
    	format.html
    	format.json { render json: EventsDatatable.new(view_context) }
  	end
  end
end
