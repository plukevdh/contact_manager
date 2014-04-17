require 'spec_helper'

describe ContactsController do
  Given { 3.times { create :contact }}

  context "get index" do
    When { get :index }
    Then { expect(assigns(:contacts).count).to eq(3) }
    Then { expect(response).to render_template(:index) }
  end

  context "get index json" do
    When { get :index, format: :json }
    When(:data) { JSON.parse(response.body) }
    Then { expect(data.count).to eq(3) }
    And { expect(data.map {|c| c["first_name"] == "John" }.all?).to be_true  }
  end
end