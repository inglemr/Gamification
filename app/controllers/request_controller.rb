class RequestController < ApplicationController
  load_and_authorize_resource
  before_filter :load_permissions

  def create_org_request
    organization = Organization.find(params[:organization_id])
    @request = Request.new(:user_id => current_user.id, :organization_id => organization.id, :status => "open")
    @request.save

    redirect_to :back

  end

  def org_accept_member
    @request = Request.find(params[:request_id])
    @request.status = "accepted"
    @user = User.find(@request.user_id)
    @organization = Organization.find(@request.organization_id)
    @user.organizations <<  @organization
    @user.save
    @organization.save
    @request.save
    redirect_to :back

  end

  def org_decline_member
    @request = Request.find(params[:request_id])
    @request.status = "declined"
    @request.save
    redirect_to :back
  end

end
