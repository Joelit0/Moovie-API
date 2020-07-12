require 'rails_helper'

RSpec.describe List, type: :model do
  before do
    @user = create(:user)
  end
  
  subject { 
    described_class.new(  name: "Movies List",
                          description: "My list",
                          public: true,
                          user_id: @user.id)}

  context "when valid" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
  end

  context "when invalid" do
    it "is not valid without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a description" do
      subject.description = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a public" do
      subject.public = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a user_id" do
      subject.user = nil
      expect(subject).to_not be_valid
    end
  end
end