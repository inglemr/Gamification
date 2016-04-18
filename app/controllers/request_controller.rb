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
    @request.status = "accepted"
    @user = User.find(@request.user_id)
    @organization = Organization.find(@request.organization_id)
    @organization.add_member(@user)
    @request.save
    redirect_to :back

  end

  def org_decline_member
    @request = Request.find(params[:request_id])
    @request.status = "declined"
    @request.save
    redirect_to :back
  end

  def org_invite_member
    @organization = Organization.find(params[:organization_id])
    @users = params[:users]
    @users.each do |id|
      @request = Request.new(:user_id => id, :organization_id => @organization.id, :status => "open",:request_type => "org-invite")
      @request.save
    end
    redirect_to :back
  end

  def org_accept_invite
    @request = Request.find(params[:request_id])
    @user = User.find(@request.user_id)
    @organization = Organization.find(@request.organization_id)
    @organization.add_member(@user)
    @request.status = "accepted"
    @request.save
    redirect_to :back
  end


  def org_decline_invite
    @request = Request.find(params[:request_id])
    @request.status = "declined"
    @request.save
    redirect_to :back
  end

end
