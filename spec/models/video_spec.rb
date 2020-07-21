require 'spec_helper'

RSpec.describe Video, type: :model do
  before do
    @movie = create(:movie)
  end

  subject {
    described_class.new(  size: 178131,
                          format: "Mp4",
                          url: "www.fakeurl.com",
                          movie_id: @movie.id)}

  context "when valid" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
  end
  
  context "when invalid" do
    it "is not valid without a size" do
      subject.size = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a format" do
      subject.format = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a url" do
      subject.url = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a movie id" do
      subject.movie_id = nil
      expect(subject).to_not be_valid
    end
  end
end