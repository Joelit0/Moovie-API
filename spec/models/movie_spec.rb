require 'rails_helper'

RSpec.describe Movie, type: :model do
  subject { 
    described_class.new(  title: "The Lord of the Rings: The Fellowship of the Ring", 
                          tagline: "One ring to rule them all", 
                          overview: "The future of civilization rests in the fate of the One Ring", 
                          release_date: "2001-01-12",
                          poster_url: "https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_.jpg",
                          backdrop_url: "https://m.media-amazon.com/images",
                          imdb_id: "3782")}

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
