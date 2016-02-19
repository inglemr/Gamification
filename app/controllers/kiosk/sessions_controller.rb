class Kiosk::SessionsController < ApplicationController
  def new
  end
  
  def create
    kiosk = Kiosk.authenticate(params[:kiosk_name], params[:password])
    if kiosk
      session[:kiosk_id] = kiosk.id
      session[:current_host] ||= user.id
      redirect_to kiosk_list_path, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid Kiosk ID or GSW ID"
      render "new"
    end
  end

	def destroy
	  session[:kiosk_id] = nil
	  redirect_to root_url, :notice => "Logged out!"
	end

end
