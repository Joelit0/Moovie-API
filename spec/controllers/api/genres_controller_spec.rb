require 'rails_helper'

RSpec.describe GenresController, type: :controller do
  before do
    @genre = create(:genre)
  end

  describe "GET #index" do
    context "when valid" do
      before do
        get :index, format: :json
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      
      it "JSON body response contains expected genre attributes" do
        expect(json.first.keys).to match_array(["id","name", "created_at", "updated_at"])
      end

      it "JSON body response contains expected genres" do
        expect(json.first['name']).to eq(@genre.name)
      end
    end
    
    context "when invalid" do
      context "when the user does not authenticate", :nil_token do
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
end