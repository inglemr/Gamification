class Admin::TagController  < ApplicationController
  load_and_authorize_resource :context => :admin
  before_filter :load_permissions
  def index
    respond_to do |format|
        format.html
        format.json { render json: Admin::TagsDatatable.new(view_context) }
      end
  end

  def show
    @tag = Tag.find(params[:id])
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])

    if @tag.update_attributes(params[:tag].permit(:name))
      redirect_to admin_tag_path, :flash => { :success => 'Tag was successfully updated.' }
    else
      redirect_to admin_tag_path, :flash => { :error => 'Tag was unsuccesfully updated.' }
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    redirect_to admin_tag_index_path
  end

  def new
    @tag = Tag.new
  end

  def create

    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to admin_tag_index_path
    else
      render 'new'
    end
  end

private

  def tag_params
    params.require(:tag).permit(:name)
  end
  def self.permission
    return "Admin::Tag"
  end
end
