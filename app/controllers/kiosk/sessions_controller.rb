class Kiosk::SessionsController < ApplicationController
  def new
    if current_kiosk
      flash[:alert] = "Already Logged In"
      redirect_to kiosk_list_path
    end
  end
  
  def create
    if current_kiosk
      flash[:alert] = "Already Logged In"
      redirect_to kiosk_list_path
    else
      kiosk = Kiosk.authenticate(params[:kiosk_name], params[:password])
      user = User.where(:gsw_id => params[:password]).first
      if kiosk
        session[:kiosk_id] = kiosk.id
        session[:current_host] ||= user.id
        redirect_to kiosk_list_path, :notice => "Logged in!"
      else
        flash.now.alert = "Invalid Kiosk ID or GSW ID"
        render "new"
      end
    end
  end

	def destroy
	  session[:kiosk_id] = nil
	  redirect_to kiosk_log_in_path, :notice => "Logged out!"
	end

end
