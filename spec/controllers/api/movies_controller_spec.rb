require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe "GET #index" do
    context "when valid" do 
      context "when all the movies are obtained correctly" do
        before do
          movie = create(:movie)
          get :index
          @json_response = JSON.parse(response.body)
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end
        
        it "JSON body response contains expected movies attributes" do
          expect(@json_response.first.keys).to match_array(["id","title", "tagline", "overview", "release_date", "poster_url", "backdrop_url", "imdb_id", "created_at", "updated_at"])
        end
        
        it "response with JSON body containing expected movie title" do
          expect(@json_response.first['title']).to eq('The Lord of the Rings: The Fellowship of the Ring')
        end

        it "response with JSON body containing expected movie tagline" do
          expect(@json_response.first['tagline']).to eq('One ring to rule them all')
        end

        it "response with JSON body containing expected movie overview" do
          expect(@json_response.first['overview']).to eq('The future of civilization rests in the fate of the One Ring')
        end
        
        it "response with JSON body containing expected movie release_date" do
          expect(@json_response.first['release_date']).to eq('2001-01-12')
        end

        it "response with JSON body containing expected movie poster_url" do
          expect(@json_response.first['poster_url']).to eq('https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_.jpg')
        end

        it "response with JSON body containing expected movie backdrop_url" do
          expect(@json_response.first['backdrop_url']).to eq('https://m.media-amazon.com/images')
        end

        it "response with JSON body containing expected movie imdb_id" do
          expect(@json_response.first['imdb_id']).to eq('3782')
        end
      end
      
      context "when movies are sorted by release_date" do
        before do
          @movie_1 = create(:movie)    
          @movie_2 = create(:movie, release_date: "2002-01-12") 
        end

        it 'sorting asc release_date' do
          get :index, params: {sort_by: 'release_date', sort_order: 'asc'}
          json_body = JSON.parse(response.body)
          expect(json_body).to match([@movie_1.as_json, @movie_2.as_json])
        end

        it 'sorting desc release_date' do
          get :index, params: {sort_by: 'release_date', sort_order: 'desc'}
          json_body = JSON.parse(response.body)
          expect(json_body).to match([@movie_2.as_json, @movie_1.as_json])
        end
      end

      context "when movies are sorted by title" do
        before do
          @movie_1 = create(:movie)    
          @movie_2 = create(:movie, title: "The Lord of the Rings: The Two Towers") 
        end

        it 'sorting asc title' do
          get :index, params: {sort_by: 'title', sort_order: 'asc'}
          json_body = JSON.parse(response.body)
          expect(json_body).to match([@movie_1.as_json, @movie_2.as_json])
        end

        it 'sorting desc title' do
          get :index, params: {sort_by: 'title', sort_order: 'desc'}
          json_body = JSON.parse(response.body)
          expect(json_body).to match([@movie_2.as_json, @movie_1.as_json])
        end
      end

      context "when movies are paged correctly" do
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

      context "when movies are filtered by title" do
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
    end
    context "when invalid" do
      context "when it returns the unexpected movie" do
        before do
          movie = create(:movie)
          get :index
          @json_response = JSON.parse(response.body)
        end

        it "JSON body response contains invalid movies attributes" do
          expect(@json_response.first.keys).to_not match_array(["invalidKey","invalidKey", "invalidKey", "invalidKey", "invalidKey", "invalidKey", "invalidKey", "invalidKey", "invalidKey", "invalidKey"])
        end
        
        it "response with JSON body containing unexpected movie title" do
          expect(@json_response.first['title']).to_not eq('Invalid title')
        end

        it "response with JSON body containing unexpected movie tagline" do
          expect(@json_response.first['tagline']).to_not eq('Invalid tagline')
        end

        it "response with JSON body containing unexpected movie overview" do
          expect(@json_response.first['overview']).to_not eq('Invalid overview')
        end
        
        it "response with JSON body containing unexpected movie release_date" do
          expect(@json_response.first['release_date']).to_not eq('Invalid date')
        end

        it "response with JSON body containing unexpected movie poster_url" do
          expect(@json_response.first['poster_url']).to_not eq('Invalid poster_url')
        end

        it "response with JSON body containing unexpected movie backdrop_url" do
          expect(@json_response.first['backdrop_url']).to_not eq('Invalid backdrop_url')
        end

        it "response with JSON body containing unexpected movie imdb_id" do
          expect(@json_response.first['imdb_id']).to_not eq('Invalid imdb_id')
        end
      end
      context "when movies are not paged correctly" do
        before do 
          21.times do 
            create(:movie)
          end
        end

        it 'to make it false, the page 1 should contain a 21 movies' do
          get :index, params: {page: 1}
          json_body = JSON.parse(response.body)
          expect(json_body.length).to_not eq 21
        end

        it 'to make it false, the page 2 should contain a 0 movie' do
          get :index, params: {page: 2}
          json_body = JSON.parse(response.body)
          expect(json_body.length).to_not eq 0
        end
      end
      context "when movies are not filtered by title correctly" do
        before do
          @movie_1 = create(:movie)    
          @movie_2 = create(:movie, title: "The Lord of the Rings: The Two Towers") 
        end

        it "to make it false, should show a movie 2" do
          get :index, params: {title: "The Lord of the Rings: The Fellowship of the Ring"}
          json_body = JSON.parse(response.body)
          expect(json_body).to_not match([@movie_2.as_json])
        end

        it "to make it false, should show a movie 1" do
          get :index, params: {title: "The Lord of the Rings: The Two Towers"}
          json_body = JSON.parse(response.body)
          expect(json_body).to_not match([@movie_1.as_json])
        end
      end
    end
  end

  describe "GET #show" do
    before do
      @movie1 = create(:movie)
      get :show, params: { id: @movie1.id }
      @json_response = JSON.parse(response.body)
    end
    context "when valid" do
      context "when it returns the expected movie" do
        it "should return http succes" do
          expect(response).to have_http_status(:success)
        end

        it "JSON body response contains expected movie attributes and contains videos" do
          expect(@json_response.first.keys).to match_array(["id","title", "tagline", "overview", "release_date", "poster_url", "backdrop_url", "imdb_id", "created_at", "updated_at", "videos"])
        end

        it "response with JSON body containing expected movie title" do
          expect(@json_response.first['title']).to eq('The Lord of the Rings: The Fellowship of the Ring')
        end
        
        it "response with JSON body containing expected movie tagline" do
          expect(@json_response.first['tagline']).to eq('One ring to rule them all')
        end
        
        it "response with JSON body containing expected movie overview" do
          expect(@json_response.first['overview']).to eq('The future of civilization rests in the fate of the One Ring')
        end
        
        it "response with JSON body containing expected movie release_date" do
          expect(@json_response.first['release_date']).to eq('2001-01-12')
        end
        
        it "response with JSON body containing expected movie poster_url" do
          expect(@json_response.first['poster_url']).to eq('https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_.jpg')
        end
        
        it "response with JSON body containing expected movie backdrop_url" do
          expect(@json_response.first['backdrop_url']).to eq('https://m.media-amazon.com/images')
        end
      
        it "response with JSON body containing expected movie imdb_id" do
          expect(@json_response.first['imdb_id']).to eq('3782')
        end

        it "response with JSON body containing expected movie videos" do
          expect(@json_response.first['videos']).to eq([])
        end
      end
    end
    context "when invalid" do
      context "when it returns the unexpected movie" do
        it "JSON body response contains invalid movie attributes" do
          expect(@json_response.first.keys).to_not match_array(["invalidKey","invalidKey", "invalidKey", "invalidKey", "invalidKey", "invalidKey", "invalidKey", "invalidKey", "invalidKey", "invalidKey"])
        end
        
        it "response with JSON body containing unexpected movie title" do
          expect(@json_response.first['title']).to_not eq('Invalid title')
        end

        it "response with JSON body containing unexpected movie tagline" do
          expect(@json_response.first['tagline']).to_not eq('Invalid tagline')
        end

        it "response with JSON body containing unexpected movie overview" do
          expect(@json_response.first['overview']).to_not eq('Invalid overview')
        end
        
        it "response with JSON body containing unexpected movie release_date" do
          expect(@json_response.first['release_date']).to_not eq('Invalid date')
        end

        it "response with JSON body containing unexpected movie poster_url" do
          expect(@json_response.first['poster_url']).to_not eq('Invalid poster_url')
        end

        it "response with JSON body containing unexpected movie backdrop_url" do
          expect(@json_response.first['backdrop_url']).to_not eq('Invalid backdrop_url')
        end

        it "response with JSON body containing unexpected movie imdb_id" do
          expect(@json_response.first['imdb_id']).to_not eq('Invalid imdb_id')
        end
      end
    end
  end
end