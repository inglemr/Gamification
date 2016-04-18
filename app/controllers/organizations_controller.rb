class OrganizationsController < ApplicationController
  load_and_authorize_resource
  before_filter :load_permissions





  def new_organization_request
    @organization = Organization.new
  end

  def create_organization_request
    @organization = Organization.new(organization_params)
    @organization.active = false
    @organizations.add_leader(current_user)
    @organization.save
    redirect_to organizations_path
  end

  def index
    respond_to do |format|
        format.html
        format.json { render json: OrganizationsDatatable.new(view_context) }
      end
  end

  def member_role
    @organization = Organization.find(params[:id])
    @user = User.find(params[:member_id])
    params['user']['_org_roles'] ||= []
    params['user']['_org_roles'].each do |id|
      if(!@user.org_roles.exists?(id))
        @user.org_roles << OrgRole.find(id)
      end
    end
    OrgRole.all.each do |role|
      if !(params['user']['_org_roles'].include?(role.id.to_s)) && @user.org_roles.exists?(role.id)
        @user.org_roles.delete(role)
      end
    end


    redirect_to :back
  end

  def edit_role
    @role = OrgRole.find(params[:role_id])
    @organization = Organization.find(params[:id])
    params['role'] ||= Hash.new
    params['role']['_permisisons'] ||= []
    @role.permissions = params['role']['_permisisons']
    @role.save

    redirect_to :back
  end


  def delete_role
    @role = OrgRole.find(params[:role_id])
    @role.destroy

    redirect_to :back
  end

  def new_role
    @organization = Organization.find(params[:id])
    @role = OrgRole.new
    @role.name = params[:name]
    @role.org_id = @organization.id
    @role.description = params[:description]
    @role.permissions = params['role']['_permisisons']
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
      elsif params[:type] == "pending"
        respond_to do |format|
          format.html
          format.json { render json: Organizations::PendingDatatable.new(view_context,@organization) }
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

  def organization_params
    params.require(:organization).permit(:name,:summary, :description)
  end

end
