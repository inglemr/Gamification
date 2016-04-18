class Admin::ResqueController < ApplicationController
  load_and_authorize_resource :context => :admin
  before_filter :load_permissions

  def index
      respond_to do |format|
        format.html {}
        format.js {}
      end
   end
end
