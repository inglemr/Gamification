class KiosksController < ApplicationController
	load_and_authorize_resource
	before_filter :load_permissions 


end
