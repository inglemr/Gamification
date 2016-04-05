class OrganizationsController < ApplicationController
  load_and_authorize_resource
  before_filter :load_permissions

  def index
    respond_to do |format|
        format.html
        format.json { render json: OrganizationsDatatable.new(view_context) }
      end
  end

  def show
    @organization = Organization.find(params[:id])
  end
end
