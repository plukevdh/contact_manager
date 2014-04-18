class Api::ContactsController < ApplicationController
  respond_to :json

  def index
    respond_with Contact.alphabetical
  end

  def create
    respond_with Contact.create safe_params
  end

  def update
    respond_with Contact.update params[:id], safe_params
  end

  private
  def safe_params
    params.require(:contact).permit!
  end
end
