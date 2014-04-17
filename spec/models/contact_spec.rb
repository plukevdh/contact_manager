require 'spec_helper'

describe Contact do
  context "full name" do
    context "can output combine names" do
      When(:contact) { build(:contact, first_name: "Mace", last_name: "Windex") }
      Then { contact.full_name.should == "Mace Windex" }
    end

    context "can parse handle normal names" do
      When(:contact) { build(:contact, full_name: "Test User") }
      Then { contact.first_name.should == "Test" }
      And { contact.last_name.should == "User" }
    end

    context "can parse longer last names" do
      When(:contact) { build(:contact, full_name: "Test van der Hoeven") }
      Then { contact.first_name.should == "Test" }
      And { contact.last_name.should == "van der Hoeven" }
    end
  end

  context "validations" do
    When(:contact) { build(:contact) }

    context "require an email" do
      When { contact.email = nil }
      Then { contact.should_not be_valid }
    end

    context "require unique emails" do
      Given!(:other) { create(:contact, email: "biz@stone.com") }
      When { contact.email = "biz@stone.com" }
      Then { contact.should_not be_valid }
      And { contact.errors[:email].should_not be_nil }
    end
  end

	context "can get users ordered by last name, then first name" do
    Given { create(:contact, first_name: "Roger", last_name: "Stone") }
    Given { create(:contact, first_name: "Bill", last_name: "Stone") }
    Given { create(:contact, first_name: "Zoe", last_name: "Barnes") }
    When(:ordered) { Contact.alphabetical }
    Then { ordered.map(&:full_name).should == ["Zoe Barnes", "Bill Stone", "Roger Stone"] }
  end
end