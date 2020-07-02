require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  before do 
    @user = create(:user)
    @token = JsonWebToken.encode(user_id: @user.id)
  end
  
  describe "GET #index" do
    context "when valid" do 
      before do
        request.headers["AUTHORIZATION"] = "Bearer #{@token}"
      end
      context "when all the movies are obtained correctly" do
        before do
          @movie = create(:movie)
          get :index
          @json_response = JSON.parse(response.body)
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end
        
        it "JSON body response contains expected movies attributes" do
          expect(@json_response.first.keys).to match_array(["id","title", "tagline", "overview", "release_date", "poster_url", "backdrop_url", "imdb_id", "created_at", "updated_at"])
        end
        
        it "JSON body response contains expected movie id" do
          expect(@json_response.first['id']).to eq(@movie.id)
        end

        it "JSON body response contains expected movie title" do
          expect(@json_response.first['title']).to eq(@movie.title)
        end

        it "JSON body response contains expected movie tagline" do
          expect(@json_response.first['tagline']).to eq(@movie.tagline)
        end

        it "JSON body response contains expected movie overview" do
          expect(@json_response.first['overview']).to eq(@movie.overview)
        end
        
        it "JSON body response contains expected movie release_date" do
          expect(@json_response.first['release_date']).to eq(@movie.release_date.to_s)
        end

        it "JSON body response contains expected movie poster_url" do
          expect(@json_response.first['poster_url']).to eq(@movie.poster_url)
        end

        it "JSON body response contains expected movie backdrop_url" do
          expect(@json_response.first['backdrop_url']).to eq(@movie.backdrop_url)
        end

        it "JSON body response contains expected movie imdb_id" do
          expect(@json_response.first['imdb_id']).to eq(@movie.imdb_id)
        end
      end
      
      context "when movies are sorted by release_date" do
        before do
          @movie_1 = create(:movie)    
          @movie_2 = create(:movie, release_date: "2002-01-12") 
        end

        it 'sorting asc release_date' do
          get :index, params: { sort_by: 'release_date', sort_order: 'asc' }
          json_body = JSON.parse(response.body)
          expect(json_body).to match([@movie_1.as_json, @movie_2.as_json])
        end

        it 'sorting desc release_date' do
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

        it 'sorting asc title' do
          get :index, params: { sort_by: 'title', sort_order: 'asc' }
          json_body = JSON.parse(response.body)
          expect(json_body).to match([@movie_1.as_json, @movie_2.as_json])
        end

        it 'sorting desc title' do
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

        it 'the page 1 should contain a 20 movies' do
          get :index, params: { page: 1 }
          json_body = JSON.parse(response.body)
          expect(json_body.length).to eq 20
        end

        it 'the page 2 should contain a 1 movie' do
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
          request.headers["AUTHORIZATION"] = "Bearer #{@token}"
        end

        it 'to make it false, the page 1 should contain a 21 movies' do
          get :index, params: { page: 1 }
          json_body = JSON.parse(response.body)
          expect(json_body.length).to_not eq 21
        end

        it 'to make it false, the page 2 should contain a 0 movie' do
          request.headers["AUTHORIZATION"] = "Bearer #{@token}"
          get :index, params: { page: 2 }
          json_body = JSON.parse(response.body)
          expect(json_body.length).to_not eq 0
        end
      end
      context "when movies are not filtered by title correctly" do
        before do
          @movie_1 = create(:movie)    
          @movie_2 = create(:movie, title: "The Lord of the Rings: The Two Towers") 
          request.headers["AUTHORIZATION"] = "Bearer #{@token}"
        end

        it "to make it false, should show a movie 2" do
          get :index, params: { title: "The Lord of the Rings: The Fellowship of the Ring" }
          json_body = JSON.parse(response.body)
          expect(json_body).to_not match([@movie_2.as_json])
        end

        it "to make it false, should show a movie 1" do
          get :index, params: { title: "The Lord of the Rings: The Two Towers" }
          json_body = JSON.parse(response.body)
          expect(json_body).to_not match([@movie_1.as_json])
        end
      end
      context  "when the user does not authenticate" do
        before do
          get :index, format: :json
          @json_response = JSON.parse(response.body)
          @nil_token = { "errors" => "Nil JSON web token" }
        end
        
        it "returns http unauthorized" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "returns an error if token is nil" do
          expect(@json_response).to eq(@nil_token)
        end
      end
    end
  end

  describe "GET #show" do
    context "when valid" do
      before do
        @movie1 = create(:movie)
        request.headers["AUTHORIZATION"] = "Bearer #{@token}"
        get :show, params: { id: @movie1.id }
        @json_response = JSON.parse(response.body)
      end
      context "when it returns the expected movie" do
        it "should return http succes" do
          expect(response).to have_http_status(:success)
        end

        it "JSON body response contains expected movies attributes" do
          expect(@json_response.keys).to match_array(["id","title", "tagline", "overview", "release_date", "poster_url", "backdrop_url", "imdb_id", "created_at", "updated_at", "videos"])
        end
        
        it "JSON body response contains expected movie title" do
          expect(@json_response['title']).to eq(@movie1.title)
        end

        it "JSON body response contains expected movie tagline" do
          expect(@json_response['tagline']).to eq(@movie1.tagline)
        end

        it "JSON body response contains expected movie overview" do
          expect(@json_response['overview']).to eq(@movie1.overview)
        end
        
        it "JSON body response contains expected movie release_date" do
          expect(@json_response['release_date']).to eq(@movie1.release_date.to_s)
        end

        it "JSON body response contains expected movie poster_url" do
          expect(@json_response['poster_url']).to eq(@movie1.poster_url)
        end

        it "JSON body response contains expected movie backdrop_url" do
          expect(@json_response['backdrop_url']).to eq(@movie1.backdrop_url)
        end

        it "JSON body response contains expected movie imdb_id" do
          expect(@json_response['imdb_id']).to eq(@movie1.imdb_id)
        end

        it "JSON body response contains expected movie videos" do
          expect(@json_response['videos']).to eq([])
        end
      end
    end
    context "when invalid" do
      context  "when the user does not authenticate" do
        before do
          @movie1 = create(:movie)
          get :show, params: { id: @movie1.id }
          @json_response = JSON.parse(response.body)
          @nil_token = { "errors" => "Nil JSON web token" }
        end

        it "returns http unauthorized" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "returns an error if token is nil" do
          expect(@json_response).to eq(@nil_token)
        end
      end
      context "when the user does not exist" do
        before do
          request.headers["AUTHORIZATION"] = "Bearer #{@token}"
          get :show, params: { id: "Invalid id" }
          @json_response = JSON.parse(response.body)
        end
        
        it "returns http not found" do
          expect(response).to have_http_status(:not_found)
        end
        
        it "The user does not exist" do
          expect(@json_response['message']).to eq('The movie does not exist')
        end
      end
    end
  end
  describe "Movies and Lists" do
    before do
      @user = create(:user)
      @movie = create(:movie)
      @list = create(:list, user_id: @user.id)
      @user1 = create(:user)
      @list1 = create(:list, user_id: @user1.id)
      @token = JsonWebToken.encode(user_id: @user.id)
    end
    
    describe "PUT #add_movie_to_a_list" do
      context "when valid" do
        before do
          request.headers["AUTHORIZATION"] = "Bearer #{@token}"
          put :add_movie_to_a_list, format: :json, params: { movie_id: @movie.id, list_id: @list.id }
          @json_response = JSON.parse(response.body)
        end
        it "returns http no content" do
          puts @json_response
          expect(response).to have_http_status(:no_content)
        end
        it "The movie has been successfully added to the list" do
          expect(@json_response['message']).to eq('The movie has been successfully added to the list')
        end
      end
    
      context "when invalid" do
        context "when the user does not authenticate" do
          before do
            put :add_movie_to_a_list, format: :json, params: { movie_id: @movie.id, list_id: @list.id }
            @json_response = JSON.parse(response.body)
            @nil_token = { "errors" => "Nil JSON web token" }
          end
    
          it "returns http unauthorized" do
            expect(response).to have_http_status(:unauthorized)
          end
  
          it "returns an error if token is nil" do
            expect(@json_response).to eq(@nil_token)
          end
        end
        
        context "when the list does not exist" do
          before do
            request.headers["AUTHORIZATION"] = "Bearer #{@token}"
            put :add_movie_to_a_list, format: :json, params:  { list_id: "False id", movie_id: @movie.id }
            @json_response = JSON.parse(response.body)
          end
          
          it "returns http unauthorized" do
            expect(response).to have_http_status(:not_found)
          end
    
          it "The user does not exist" do
            expect(@json_response['message']).to eq('The list does not exist')
          end
        end

        context "when the movie does not exist" do
          before do
            request.headers["AUTHORIZATION"] = "Bearer #{@token}"
            put :add_movie_to_a_list, format: :json, params:  { list_id: @list.id, movie_id: "False id" }
            @json_response = JSON.parse(response.body)
          end
          
          it "returns http unauthorized" do
            expect(response).to have_http_status(:not_found)
          end
    
          it "The user does not exist" do
            expect(@json_response['message']).to eq('The movie does not exist')
          end
        end
        
        context "when the user's token does not match the user to display" do
          before do
            request.headers["AUTHORIZATION"] = "Bearer #{@token}"
            put :add_movie_to_a_list, format: :json, params: { movie_id: @movie.id, list_id: @list1.id }
            @json_response = JSON.parse(response.body)
          end
          it "returns http unauthorized" do
            expect(response).to have_http_status(:unauthorized)
          end
          it "The user does not exist" do
            expect(@json_response['message']).to eq("You cannot add movies to other users' lists")
          end
        end
      end
    end
  end
end