require "spec_helper"

RSpec.describe MoviesController, type: :controller do
  describe "GET #index" do
    context "when valid" do 

      context "when all the movies are obtained correctly" do
        before do
          @movie = create(:movie)
          get :index
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end
        
        it "JSON body response contains expected movies attributes" do
          expect(json.first.keys).to match_array(["id","title", "tagline", "overview", "release_date", "poster_url", "backdrop_url", "imdb_id", "created_at", "updated_at"])
        end
        
        it "JSON body response contains expected movie id" do
          expect(json.first['id']).to eq(@movie.id)
        end

        it "JSON body response contains expected movie title" do
          expect(json.first['title']).to eq(@movie.title)
        end

        it "JSON body response contains expected movie tagline" do
          expect(json.first['tagline']).to eq(@movie.tagline)
        end

        it "JSON body response contains expected movie overview" do
          expect(json.first['overview']).to eq(@movie.overview)
        end
        
        it "JSON body response contains expected movie release_date" do
          expect(json.first['release_date']).to eq(@movie.release_date.to_s)
        end

        it "JSON body response contains expected movie poster_url" do
          expect(json.first['poster_url']).to eq(@movie.poster_url)
        end

        it "JSON body response contains expected movie backdrop_url" do
          expect(json.first['backdrop_url']).to eq(@movie.backdrop_url)
        end

        it "JSON body response contains expected movie imdb_id" do
          expect(json.first['imdb_id']).to eq(@movie.imdb_id)
        end
      end
      
      context "when movies are sorted by release_date" do
        before do
          @movie_1 = create(:movie)    
          @movie_2 = create(:movie, release_date: "2002-01-12") 
        end

        it "sorting asc release_date" do
          get :index, params: { sort_by: 'release_date', sort_order: 'asc' }
          json_body = JSON.parse(response.body)
          expect(json_body).to match([@movie_1.as_json, @movie_2.as_json])
        end

        it "sorting desc release_date" do
          get :index, params: { sort_by: 'release_date', sort_order: 'desc' }
          json_body = JSON.parse(response.body)
          expect(json_body).to match([@movie_2.as_json, @movie_1.as_json])
        end
      end

      context "when movies are sorted by title" do
        before do
          @movie_1 = create(:movie)    
          @movie_2 = create(:movie, title: "The Lord of the Rings: The Two Towers") 
        end

        it "sorting asc title" do
          get :index, params: { sort_by: 'title', sort_order: 'asc' }
          json_body = JSON.parse(response.body)
          expect(json_body).to match([@movie_1.as_json, @movie_2.as_json])
        end

        it "sorting desc title" do
          get :index, params: { sort_by: 'title', sort_order: 'desc' }
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

        it "the page 1 should contain 20 movies" do
          get :index, params: { page: 1 }
          json_body = JSON.parse(response.body)
          expect(json_body.length).to eq 20
        end

        it "the page 2 should contain 1 movie" do
          get :index, params: { page: 2 }
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
          get :index, params: { title: "The Lord of the Rings: The Fellowship of the Ring" }
          json_body = JSON.parse(response.body)
          expect(json_body).to match([@movie_1.as_json])
        end

        it "should show a movie 2" do
          get :index, params: { title: "The Lord of the Rings: The Two Towers" }
          json_body = JSON.parse(response.body)
          expect(json_body).to match([@movie_2.as_json])
        end
      end
    end

    context "when invalid" do
      context "when movies are not paged correctly" do
        before do 
          21.times do 
            create(:movie)
          end
        end

        it "to make it false, the page 1 should contain 21 movies" do
          get :index, params: { page: 1 }
          json_body = JSON.parse(response.body)
          expect(json_body.length).to_not eq 21
        end

        it "to make it false, the page 2 should contain 0 movies" do
          get :index, params: { page: 2 }
          json_body = JSON.parse(response.body)
          expect(json_body.length).to_not eq 0
        end
      end

      context  "when the user does not authenticate", :nil_token do
        before do
          get :index, format: :json
          @nil_token = { "errors" => "Nil JSON web token" }
        end
        
        it "returns http unauthorized" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "returns an error if token is nil" do
          expect(json).to eq(@nil_token)
        end
      end
    end
  end

  describe "GET #show" do
    context "when valid" do
      before do
        @movie1 = create(:movie)      
        get :show, params: { id: @movie1.id }
      end

      context "when it returns the expected movie" do
        it "should return http succes" do
          expect(response).to have_http_status(:success)
        end

        it "JSON body response contains expected movies attributes" do
          expect(json.keys).to match_array(["id","title", "tagline", "overview", "release_date", "poster_url", "backdrop_url", "imdb_id", "created_at", "updated_at", "videos"])
        end
        
        it "JSON body response contains expected movie title" do
          expect(json['title']).to eq(@movie1.title)
        end

        it "JSON body response contains expected movie tagline" do
          expect(json['tagline']).to eq(@movie1.tagline)
        end

        it "JSON body response contains expected movie overview" do
          expect(json['overview']).to eq(@movie1.overview)
        end
        
        it "JSON body response contains expected movie release_date" do
          expect(json['release_date']).to eq(@movie1.release_date.to_s)
        end

        it "JSON body response contains expected movie poster_url" do
          expect(json['poster_url']).to eq(@movie1.poster_url)
        end

        it "JSON body response contains expected movie backdrop_url" do
          expect(json['backdrop_url']).to eq(@movie1.backdrop_url)
        end

        it "JSON body response contains expected movie imdb_id" do
          expect(json['imdb_id']).to eq(@movie1.imdb_id)
        end

        it "JSON body response contains expected movie videos" do
          expect(json['videos']).to eq([])
        end
      end
    end

    context "when invalid" do
      context  "when the user does not authenticate", :nil_token do
        before do
          @movie1 = create(:movie)
          get :show, params: { id: @movie1.id }
          @nil_token = { "errors" => "Nil JSON web token" }
        end

        it "returns http unauthorized" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "returns an error if token is nil" do
          expect(json).to eq(@nil_token)
        end
      end
      
      context "when the user does not exist" do
        before do
          get :show, params: { id: "Invalid id" }
        end
        
        it "returns http not found" do
          expect(response).to have_http_status(:not_found)
        end
        
        it "The user does not exist" do
          expect(json['message']).to eq('The movie does not exist')
        end
      end
    end
  end
end
