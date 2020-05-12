require 'rails_helper'

RSpec.describe GenresController, type: :controller do
  describe "GET #index" do
    before do
      genre = create(:genre)
      get :index
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "JSON body response contains expected genre attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response.first.keys).to match_array(["id","name", "created_at", "updated_at"])
    end
    it "response with JSON body containing expected genres" do
      json_response = JSON.parse(response.body)
      expect(json_response.first['name']).to eq('MyString')
    end
  end
end