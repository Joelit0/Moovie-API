require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe "GET #index" do
    before do
      movie = create(:movie)
      get :index
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "JSON body response contains expected movies attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response.first.keys).to match_array(["id","title", "tagline", "overview", "release_date", "poster_url", "backdrop_url", "imdb_id", "created_at", "updated_at"])
    end
    it "response with JSON body containing expected movies" do
      json_response = JSON.parse(response.body)
      expect(json_response.first['title']).to eq('MyString')
      expect(json_response.first['tagline']).to eq('MyString')
      expect(json_response.first['overview']).to eq('MyString')
      expect(json_response.first['release_date']).to eq('2020-04-21')
      expect(json_response.first['poster_url']).to eq('MyString')
      expect(json_response.first['backdrop_url']).to eq('MyString')
      expect(json_response.first['imdb_id']).to eq('MyString')
    end
  end
  
  describe "GET #show" do
    before do
      @movie1 = create(:movie)
      get :show, params: { id: @movie1.id }
    end
    
    it "should return http succes" do
      expect(response).to have_http_status(:success)
    end
    it "JSON body response contains expected movie attributes and contains videos" do
      json_response = JSON.parse(response.body)
      expect(json_response.first.keys).to match_array(["id","title", "tagline", "overview", "release_date", "poster_url", "backdrop_url", "imdb_id", "created_at", "updated_at", "videos"])
    end
    it "response with JSON body containing expected movie" do
      json_response = JSON.parse(response.body)
      expect(json_response.first['title']).to eq('MyString')
      expect(json_response.first['tagline']).to eq('MyString')
      expect(json_response.first['overview']).to eq('MyString')
      expect(json_response.first['release_date']).to eq('2020-04-21')
      expect(json_response.first['poster_url']).to eq('MyString')
      expect(json_response.first['backdrop_url']).to eq('MyString')
      expect(json_response.first['imdb_id']).to eq('MyString')
      expect(json_response.first['videos']).to eq([])
    end
  end
end