class RequestController < ApplicationController
  load_and_authorize_resource
  before_filter :load_permissions

  def create_org_request
    organization = Organization.find(params[:organization_id])
    @request = Request.new(:user_id => current_user.id, :organization_id => organization.id, :status => "open",:request_type => "org-join")
    @request.save
    redirect_to :back
  end

  def org_accept_member
    @request = Request.find(params[:request_id])
    @organization = Organization.find(@request.organization_id)
    @user = User.find(@request.user_id)
    @org_perms = organization_perms(@organization)

    if (current_user.organizations.include? @organization) && ( @org_perms.include?("everything")  || @org_perms.include?("manage-invites")  )
      @request.status = "accepted"
      @organization.add_member(@user)
      @request.save
      redirect_to :back , :flash => { 'success' => 'Member Accepted' }
    else
      redirect_to :back , :flash => { 'error' => 'Unauthorized.' }
    end
  end

  def org_decline_member
    @request = Request.find(params[:request_id])
    @organization = Organization.find(@request.organization_id)
    @org_perms = organization_perms(@organization)

    if (current_user.organizations.include? @organization) && ( @org_perms.include?("everything")  || @org_perms.include?("manage-invites")  )
      @request.status = "declined"
      @request.save
      redirect_to :back , :flash => { 'success' => 'Member Declined' }
    else
      redirect_to :back , :flash => { 'error' => 'Unauthorized.' }
    end
  end

  def org_invite_member
    @organization = Organization.find(params[:organization_id])
    @org_perms = organization_perms(@organization)

    if (current_user.organizations.include? @organization) && ( @org_perms.include?("everything")  || @org_perms.include?("manage-invites")  )
      @users = params[:users]
      @users.each do |id|
        @request = Request.new(:user_id => id, :organization_id => @organization.id, :status => "open",:request_type => "org-invite")
        @request.save
      end
      redirect_to :back , :flash => { 'success' => 'Members Invited' }
    else
      redirect_to :back , :flash => { 'error' => 'Unauthorized.' }
    end
  end

  def org_accept_invite
    @request = Request.find(params[:request_id])
    @user = User.find(@request.user_id)
    if @user.id == current_user.id
      @organization = Organization.find(@request.organization_id)
      @organization.add_member(@user)
      @request.status = "accepted"
      @request.save
      redirect_to :back , :flash => { 'success' => 'Invitation Accepted' }
    else
      redirect_to :back , :flash => { 'error' => 'Unauthorized.' }
    end
  end


  def org_decline_invite
    @request = Request.find(params[:request_id])
    @user = User.find(@request.user_id)
    if @user.id == current_user.id
      @request.status = "declined"
      @request.save
      redirect_to :back , :flash => { 'success' => 'Invitation Declined' }
    else
      redirect_to :back , :flash => { 'error' => 'Unauthorized.' }
    end
  end

  def organization_perms(organization)
    org_perms = Array.new
     current_user.org_roles.where(:org_id => organization.id).each do |role|
        role.permissions.each do |perm|
          org_perms << perm.to_s.gsub('"', '')
        end
     end
    @org_perms = org_perms.uniq
  end
end
