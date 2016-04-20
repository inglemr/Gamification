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

end
