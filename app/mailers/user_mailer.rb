class UserMailer < ActionMailer::Base
	 helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
	 default from: "gsw.gameification@gmail.com"
  layout 'mailer'
end
