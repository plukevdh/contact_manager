require 'spec_helper'

describe Api::ContactsController do
  Given { 3.times { create :contact }}

  context "get index" do
    When { get :index, format: :json }

    context "responds with all records as json" do
      Then { expect(json_response.size).to eq(3) }
    end

    context "returns records alphabetically by last then first name" do
      Given { create :contact, { full_name: "Admiral Ackbar" }}
      Given { create :contact, { full_name: "Derek Zoolander" }}

      Then { expect(json_response.first["last_name"]).to eq("Ackbar") }
      And { expect(json_response.last["last_name"]).to eq("Zoolander") }
    end
  end

  context "get index json" do
    When { get :index, format: :json }
    Then { expect(json_response.count).to eq(3) }
    And { expect(json_response.map {|c| c["full_name"] == "John Doe" }.all?).to be_true  }
  end

  context "update" do
    context "can update records" do
      Given(:record) { create :contact }
      When { put :update, contact: {full_name: "Admiral Ackbar"}, id: record.id, format: :json }
      Then { expect(response.status).to eq(204) }
    end

    context "responds with good error message" do
      Given(:record) { create :contact }
      When { put :update, contact: {email: nil}, id: record.id, format: :json }
      Then { expect(response.status).to eq(422) }
      And { expect(json_response['errors'].keys).to include('email')}
    end
  end

  context "create" do
    context "can add create records" do
      Given(:attrs) { build(:contact, name: "Bin Stubs").attributes }
      When { post :create, contact: attrs, format: :json }
      Then { expect(response.status).to eq(201) }
      And { expect(json_response['full_name']).to eq("Bin Stubs") }
    end
  end
end