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
      expect(json_response.first['title']).to eq('The Lord of the Rings: The Fellowship of the Ring')
      expect(json_response.first['tagline']).to eq('One ring to rule them all')
      expect(json_response.first['overview']).to eq('The future of civilization rests in the fate of the One Ring')
      expect(json_response.first['release_date']).to eq('2001-01-12')
      expect(json_response.first['poster_url']).to eq('https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_.jpg')
      expect(json_response.first['backdrop_url']).to eq('https://m.media-amazon.com/images')
      expect(json_response.first['imdb_id']).to eq('3782')
    end
  end

  describe "GET #index?sorting" do
    it 'sorting asc release_date' do
      @movie_1 = create(:movie)    
      @movie_2 = create(:movie, release_date: "2002-01-12") 
      get :index, params: {sort_by: 'release_date', sort_order: 'asc'}
      json_body = JSON.parse(response.body)
      expect(json_body).to match([@movie_1.as_json, @movie_2.as_json])
    end
    it 'sorting desc release_date' do
      @movie_1 = create(:movie)    
      @movie_2 = create(:movie, release_date: "2002-01-12") 
      get :index, params: {sort_by: 'release_date', sort_order: 'desc'}
      json_body = JSON.parse(response.body)
      expect(json_body).to match([@movie_2.as_json, @movie_1.as_json])
    end
    it 'sorting asc title' do
      @movie_1 = create(:movie)    
      @movie_2 = create(:movie, title: "The Lord of the Rings: The Two Towers") 
      get :index, params: {sort_by: 'title', sort_order: 'asc'}
      json_body = JSON.parse(response.body)
      expect(json_body).to match([@movie_1.as_json, @movie_2.as_json])
    end
    it 'sorting desc title' do
      @movie_1 = create(:movie)    
      @movie_2 = create(:movie, title: "The Lord of the Rings: The Two Towers") 
      get :index, params: {sort_by: 'title', sort_order: 'desc'}
      json_body = JSON.parse(response.body)
      expect(json_body).to match([@movie_2.as_json, @movie_1.as_json])
    end
  end

  describe "GET #index?paging" do
    before do 
      21.times do 
        create(:movie)
      end
    end
    it 'the page 1 should contain a 20 movies' do
      get :index, params: {page: 1}
      json_body = JSON.parse(response.body)
      expect(json_body.length).to eq 20
    end
    it 'the page 2 should contain a 1 movie' do
      get :index, params: {page: 2}
      json_body = JSON.parse(response.body)
      expect(json_body.length).to eq 1
    end
  end
  
  describe "GET #index?filtering" do
    before do
      @movie_1 = create(:movie)    
      @movie_2 = create(:movie, title: "The Lord of the Rings: The Two Towers") 
    end
    it "should show a movie 1" do
      get :index, params: {title: "The Lord of the Rings: The Fellowship of the Ring"}
      json_body = JSON.parse(response.body)
      expect(json_body).to match([@movie_1.as_json])
    end
    it "should show a movie 2" do
      get :index, params: {title: "The Lord of the Rings: The Two Towers"}
      json_body = JSON.parse(response.body)
      expect(json_body).to match([@movie_2.as_json])
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
      expect(json_response.first['title']).to eq('The Lord of the Rings: The Fellowship of the Ring')
      expect(json_response.first['tagline']).to eq('One ring to rule them all')
      expect(json_response.first['overview']).to eq('The future of civilization rests in the fate of the One Ring')
      expect(json_response.first['release_date']).to eq('2001-01-12')
      expect(json_response.first['poster_url']).to eq('https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_.jpg')
      expect(json_response.first['backdrop_url']).to eq('https://m.media-amazon.com/images')
      expect(json_response.first['imdb_id']).to eq('3782')
      expect(json_response.first['videos']).to eq([])
    end
  end
end