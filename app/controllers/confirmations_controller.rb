class ConfirmationsController < Devise::ConfirmationsController
  # Remove the first skip_before_filter (:require_no_authentication) if you
  # don't want to enable logged users to access the confirmation page.
  skip_before_filter :require_no_authentication
  skip_before_filter :authenticate_user!

  # PUT /resource/confirmation
  def update
    with_unconfirmed_confirmable do
      if @confirmable.has_no_password?
        @confirmable.attempt_set_password(params[:user])
        if @confirmable.valid? and @confirmable.password_match?
          do_confirm
        else
          do_show
          @confirmable.errors.clear #so that we wont render :new
        end
      else
        @confirmable.errors.add(:email, :password_already_set)
      end
    end

    if !@confirmable.errors.empty?
      self.resource = @confirmable
      render 'users/confirmations/new' #Change this if you don't have the views on default path
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    with_unconfirmed_confirmable do
      if @confirmable.has_no_password?
        do_show and return
      else
        do_confirm and return
      end
    end
    unless @confirmable.errors.empty?
      self.resource = @confirmable
      render 'users/confirmations/new' and return #Change this if you don't have the views on default path
    end
  end

  protected

  def with_unconfirmed_confirmable
    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
    if !@confirmable.new_record?
      @confirmable.only_if_unconfirmed {yield}
    end
  end

  def do_show
    @original_token = params[:confirmation_token]
    confirmation_token = Devise.token_generator.digest(User, :confirmation_token, @original_token)
    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, @original_token)
    @requires_password = true
    self.resource = @confirmable
    render 'users/confirmations/show' #Change this if you don't have the views on default path
  end

  def do_confirm
    savedSwipes = SavedSwipe.where(:gsw_id => @confirmable.gsw_id)
    if(savedSwipes.size > 0)
      savedSwipes.each do |swipe|
        tempEvent = Event.find(swipe.event_id)
        tempEvent.add_attendee(@confirmable)
      end
      #This is just to make sure that all saved swipes were correctly added to the user before deleting all the records
      if(savedSwipes.size == @confirmable.attended_events.size)
        savedSwipes.destroy_all
      end
    end
    @confirmable.create_activity action: 'new_sign_up',owner: @confirmable
    @confirmable.confirm
    set_flash_message :notice, :confirmed
    sign_in_and_redirect(resource_name, @confirmable)
  end
end
