require 'rails_helper'

RSpec.describe Movie, type: :model do
  subject { 
    described_class.new(  title: "MyString", 
                          tagline: "MyString", 
                          overview: "MyString", 
                          release_date: "2020-04-21",
                          poster_url: "MyString",
                          backdrop_url: "MyString",
                          imdb_id: "MyString")
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end
  
  it "is not valid without a title" do
    subject.title = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a tagline" do
    subject.tagline = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a overview" do
    subject.overview = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a release_date" do
    subject.release_date = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a poster_url" do
    subject.poster_url = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a backdrop_url" do
    subject.backdrop_url = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a imdb_id" do
    subject.imdb_id = nil
    expect(subject).to_not be_valid
  end
end
