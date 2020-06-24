require 'rails_helper'

RSpec.describe GenresController, type: :controller do
  before do
    @genre = create(:genre)
    @user = create(:user)
    @token = JsonWebToken.encode(user_id: @user.id)
  end
  describe "GET #index" do
    context "when valid" do
      before do
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

      it "JSON body response contains expected genres" do
        expect(@json_response.first['name']).to eq(@genre.name)
      end
    end
    context "when invalid" do
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