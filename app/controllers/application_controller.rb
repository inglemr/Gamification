class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_kiosk
  before_filter :load_permissions 
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :configure_devise_params, if: :devise_controller?
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.


def authenticate_kiosk
  if current_kiosk

  else
    redirect_to kiosk_log_in_path
    flash[:alert] = "Not logged in"
  end
end

  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :username, :gsw_id, :gsw_pin, :password, :password_confirmation)
    end
  end

  def current_host
    return unless session[:current_host]
    @current_host ||= User.find(session[:current_host])
  end

private
  def authenticate_token!
    authenticate_or_request_with_http_token do |token, options|
      @api_user = User.find_by(api_token: token)
      sign_in(@api_user)
    end
  end

  def end_api_session
    sign_out(@api_user)
  end

  def log_call
    log = Log.new
    log.user_id = @api_user.id
    log.params = params
    log.path = params[:controller] + "#" + params[:action]
    log.save
  end

  def after_sign_out_path_for(resource_or_scope)
     if resource_or_scope == :user
        root_path
     else
        new_kiosk_session_path
     end
  end

private

  def current_kiosk
    @current_kiosk ||= Kiosk.find(session[:kiosk_id]) if session[:kiosk_id]
  end


protected


  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :kiosk_name, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :kiosk_name,:email, :password, :password_confirmation, :current_password) }
  end


  def self.permission
    return name = self.name.gsub('Controller','').singularize.split('::').last.constantize.name rescue nil
  end
  
  def load_permissions
    @current_permissions = Hash.new []
    if current_user
      current_user.roles.each do |role|
        role.permissions.each do |perm|
          @current_permissions[perm.subject_class] << perm.action
        end
      end
    elsif @api_user
      @api_user.roles.each do |role|
        role.permissions.each do |perm|
          @current_permissions[perm.subject_class] << perm.action
        end
      end
    end
  end


end