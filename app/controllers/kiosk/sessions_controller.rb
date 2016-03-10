class Kiosk::SessionsController < ApplicationController
  def new
    if current_host
      flash[:alert] = "Already Logged In"
      redirect_to kiosk_list_path
    elsif current_user
      flash[:alert] = "Already Logged In"
      redirect_to root_path
    else
      redirect_to new_kiosk_session_path
    end
  end

  def create
    if current_host
      flash[:alert] = "Already Logged In"
      redirect_to kiosk_list_path
    elsif current_user
      flash[:alert] = "Already Logged In"
      redirect_to root_path
    else
      id = params[:password]
      if(id.length == 16)
        id = id[4,9]
      end
      user = User.where(:gsw_id => id).first
      if user
        session[:current_host] ||= user.id
        redirect_to kiosk_list_path, :notice => "Logged in!"
      else
        flash.now.alert = "Invalid Kiosk ID or GSW ID"
        render "new"
      end
    end
  end

	def destroy
	  session[:current_host] = nil
	  redirect_to kiosk_log_in_path, :notice => "Logged out!"
	end

end
