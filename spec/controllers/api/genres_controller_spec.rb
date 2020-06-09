require 'rails_helper'

RSpec.describe GenresController, type: :controller do
  describe "GET #index" do
    context "when valid" do
      before do
        genre = create(:genre)
        @user = create(:user)
        @token = JsonWebToken.encode(user_id: @user.id)
        request.headers["AUTHORIZATION"] = "Bearer #{@token}"
        get :index, format: :json
        @json_response = JSON.parse(response.body)
      end
      
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      
      it "JSON body response contains expected genre attributes" do
        expect(@json_response.first.keys).to match_array(["id","name", "created_at", "updated_at"])
      end

      it "response with JSON body containing expected genres" do
        expect(@json_response.first['name']).to eq('Horror')
      end
    end
    context "when invalid" do
      before do
        genre = create(:genre)
        @user = create(:user)
        @token = JsonWebToken.encode(user_id: @user.id)
        request.headers["AUTHORIZATION"] = "Bearer #{@token}"
        get :index, format: :json

        @json_response = JSON.parse(response.body)
      end
      
      it "JSON body response contains invalid genre attributes" do
        expect(@json_response.first.keys).to_not match_array(["invalid key","invalid key", "invalid key", "invalid key"])
      end
     
      it "response with JSON body containing invalid genres" do
        expect(@json_response.first['name']).to_not eq('Invalid Genre')
      end
    end
  end
end
