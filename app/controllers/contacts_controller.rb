class ContactsController < ApplicationController
  respond_to :html, :json

  def index
    @contacts = Contact.all

    respond_with @contacts
  end
end
