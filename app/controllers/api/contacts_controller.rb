class Api::ContactsController < ApplicationController
  respond_to :json
  wrap_parameters exclude: [] # allows full_name to pass through wrap_parameters

  def index
    respond_with Contact.alphabetical
  end

  def create
    respond_with Contact.create(safe_params), location: nil
  end

  def update
    respond_with Contact.update(params[:id], safe_params), location: nil
  end

  private
  def safe_params
    params.require(:contact).permit!
  end
end
