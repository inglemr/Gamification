class UserMailer < ActionMailer::Base
	 helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
	 default from: "Gamification <gsw.gameification@gmail.com>"
  layout 'mailer'
  include Devise::Mailers::Helpers

  def confirmation_instructions(record, token, opts={})
    @token = token
    devise_mail(record, :confirmation_instructions, opts)
  end

  def reset_password_instructions(record, token, opts={})
    @token = token
    devise_mail(record, :reset_password_instructions, opts)
  end

  def unlock_instructions(record, token, opts={})
    @token = token
    devise_mail(record, :unlock_instructions, opts)
  end

  def given_role(user, role)
    @user = user
    @role = role
    mail(to: @user.email, subject: "[Gamification] #{role.name} Access Given")
  end

  def removed_role(user, role)
    @user = user
    @role = role
    mail(to: @user.email, subject: "[Gamification] #{role.name} Access Removed")
  end

  def invited_to_organization(user, organization)
    @user = user
    @organization = organization
    mail(to: @user.email, subject: "[Gamification] Invited To Organization: #{@organization.name}")
  end

  def organization_accepted_you(user, organization)
    @user = user
    @organization = organization
    mail(to: @user.email, subject: "[Gamification] #{@organization.name} Accepted Your Membership Request")
  end

  def new_member_request(user, member, organization)
    @user = user
    @member = member
    @organization = organization
    mail(to: @user.email, subject: "[Gamification] #{@member.email} Requsted Membership to join #{@organization.name} ")
  end

  def event_added(user, event)
    @user = user
    @event = event
    mail(to: @user.email, subject: "[Gamification] #{event.event_name} Attendance Confirmation ")
  end

  def host_access_given(user,event)
    @user = user
    @event = event
    mail(to: @user.email, subject: "[Gamification] Added as host of #{event.event_name}")
  end

  def host_access_removed(user,event)
    @user = user
    @event = event
    mail(to: @user.email, subject: "[Gamification] Removed as host of #{event.event_name}")
  end

  def organization_status_change(user,organization)
    @user = user
    @organization = organization

    if(@organization.active)
      @status = "Activated"
    else
      @status = "Deactivated"
    end

    mail(to: @user.email, subject: "[Gamification] Organization #{@organization.name} has been #{@status}")
  end

end
