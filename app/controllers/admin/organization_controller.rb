class Admin::OrganizationController < ApplicationController
  load_and_authorize_resource :context => :admin
  before_filter :load_permissions

  def index
    respond_to do |format|
        format.html
        format.json { render json: Admin::OrganizationsDatatable.new(view_context) }
      end
  end

  def show
    @organization = Organization.find(params[:id])
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def update
#   current_users = @organization.users
#    params[:organization][:id] ||= []
#    users = params[:organization][:id]
#    params[:organization].delete(:id)
#    remove_host = Array.new
#    current_users.each do |host|
#      if !users.include?(host.id)
#        @organization.remove_member(host)
#      end
#    end
#    if users.size > 0
#      users.each do |host|
#        if host.length > 0
#          user = User.find(host)
#          @organization.add_member(user)
#        end
#      end
#    end


    @organization = Organization.find(params[:id])
    old_status = @organization.active
    if @organization.update_attributes(organization_params)
      if old_status != @organization.active

        @organization.users.each do |user|
          if user.notification_settings[:organizations] == "true"
            UserMailer.organization_status_change(user,@organization).deliver_now
          end
          @organization.create_activity action: 'status_change',recipient: user, parameters: {status: @organization.active}, owner: current_user
        end
      end
      redirect_to admin_organization_index_path, :flash => { :success => 'organization was successfully updated.' }
    else
      redirect_to admin_organization_index_path, :flash => { :error => 'organization was unsuccesfully updated.' }
    end
  end

  def new
    @organization = Organization.new
  end

  def create

#    current_users = @organization.users
#    params[:organization][:id] ||= []
#    users = params[:organization][:id]
#    params[:organization].delete(:id)
#    remove_host = Array.new
#    current_users.each do |host|
#      if !users.include?(host.id)
#        @organization.remove_member(host)
#      end
#    end
#    if users.size > 0
#      users.each do |host|
#        if host.length > 0
#          user = User.find(host)
#          @organization.add_member(user)
#        end
#      end
#    end

    @organization = Organization.new(organization_params)
    @organization.created_by = current_user.id
    if @organization.save
      redirect_to admin_organization_index_path
    else
      render 'new'
    end
  end

def destroy
  @organization = Organization.find(params[:id])
  @organization.destroy
  redirect_to admin_organization_index_path
end

private
  def organization_params
    params.require(:organization).permit(:name,:summary, :description,:active,:image,)
  end
end
