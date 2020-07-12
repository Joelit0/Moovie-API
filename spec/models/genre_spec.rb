require 'spec_helper'

RSpec.describe Genre, type: :model do
  subject { 
    described_class.new(name: "Horror")
  }

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
  end
end