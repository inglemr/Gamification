class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_devise_params, if: :devise_controller?
  
  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :username, :gsw_id, :gsw_pin, :password, :password_confirmation)
    end
  end


private
  def authenticate_token!
    authenticate_or_request_with_http_token do |token, options|
      @api_user = User.find_by(api_token: token)
    end
  end

  def log_call
    log = Log.new
    log.user_id = @api_user.id
    log.params = params
    log.path = params[:controller] + "#" + params[:action]
    log.save
  end

protected
  def self.permission
    return name = self.name.gsub('Controller','').singularize.split('::').last.constantize.name rescue nil
  end
  
  def load_permissions
    @current_permissions = Hash.new
    current_user.roles.each do |role|
      role.permissions.each do |perm|
        @current_permissions[perm.subject_class] = perm.action
      end
    end
  end


end