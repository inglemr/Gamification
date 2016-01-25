class HomeController < ApplicationController
	def index
		@users = User.sorted
	end

	def show
		@user = User.find(params[:id])
	end

	def edit
	end

	def delete
	end
end
