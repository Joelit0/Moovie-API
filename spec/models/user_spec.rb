require 'rails_helper'

RSpec.describe User, type: :model do
  subject { 
    described_class.new(  email: "test@gmail.com", 
                          password: "12345678", 
                          full_name: "Joel Alayon",
                          photo_path: "www.url.com"
                        )}

  context "when valid" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
  end

  context "when invalid" do
    it "is not valid without a email" do
      subject.email = nil
      expect(subject).to_not be_valid
    end
    it "is not valid without a password" do
      subject.password = nil
      expect(subject).to_not be_valid
    end
    it "is not valid without a full_name" do
      subject.full_name = nil
      expect(subject).to_not be_valid
    end
    it "is not valid without a photo_path" do
      subject.photo_path = nil
      expect(subject).to be_valid
    end
  end
end