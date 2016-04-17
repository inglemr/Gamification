class OrganizationsController < ApplicationController
  load_and_authorize_resource
  before_filter :load_permissions

  def index
    respond_to do |format|
        format.html
        format.json { render json: OrganizationsDatatable.new(view_context) }
      end
  end

  def new_role
    @organization = Organization.find(params[:id])
    @role = OrgRole.new
    @role.name = params[:name]
    @role.org_id = @organization.id
    @role.save
    redirect_to :back
  end

  def show
    @organization = Organization.find(params[:id])
  end

  def member_page
    temp = Organization.find(params[:id])
    if current_user.organizations.include?(temp)
      @organization = Organization.find(params[:id])
      if params[:type] == "roster"
        respond_to do |format|
          format.html
          format.json { render json: Organizations::RosterDatatable.new(view_context,@organization) }
        end
      elsif params[:type] == "roles"
        respond_to do |format|
          format.html
          format.json { render json: Organizations::RolesDatatable.new(view_context,@organization) }
        end
      else
        respond_to do |format|
          format.html
          format.json { render json: Organizations::EventsDatatable.new(view_context,@organization) }
        end
      end
    else
      redirect_to organizations_path
      flash[:danger] = "Unauthorized"
    end
  end
end
