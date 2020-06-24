require 'rails_helper'

RSpec.describe ListsController, type: :controller do
  before do
    @user = create(:user)
    @user1 = create(:user)
    @list = create(:list, user_id: @user.id)8
    @token = JsonWebToken.encode(user_id: @user.id)
  end
  
  describe "GET #show_users_lists" do
    context "when valid" do
      before do
        request.headers["AUTHORIZATION"] = "Bearer #{@token}"
        get :index, format: :json, params: { id: @user.id }
        @json_response = JSON.parse(response.body)
      end
      
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      
      it "JSON body response contains expected lists attributes" do
        expect(@json_response.first.keys).to match_array(["created_at", "description", "id", "name", "public", "updated_at", "user_id"])
      end

      it "JSON body response contains expected list name" do
        expect(@json_response.first['name']).to eq('Movies List')
      end
      
      it "JSON body response contains expected list description" do
        expect(@json_response.first['description']).to eq('My list')
      end

      it "JSON body response contains expected list id" do
        expect(@json_response.first['id']).to eq(@list.id)
      end

      it "JSON body response contains expected list state" do
        expect(@json_response.first['public']).to eq(true)
      end

      it "JSON body response contains user id of expected list" do
        expect(@json_response.first['user_id']).to eq(@user.id)
      end
    end
    context "when invalid" do
      context "when the user does not authenticate" do
        before do
          get :index, format: :json, params: { id: @user.id }
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
          get :index, format: :json, params: { id: "False id" }
          @json_response = JSON.parse(response.body)
        end
        
        it "returns http unauthorized" do
          expect(response).to have_http_status(:not_found)
        end

        it "The user does not exist" do
          expect(@json_response['message']).to eq('The user does not exist')
        end
      end
    end
    context "when the user's token does not match the user to display" do
      before do
        request.headers["AUTHORIZATION"] = "Bearer #{@token}"
        get :index, format: :json, params: { id: @user1.id }
        @json_response = JSON.parse(response.body)
      end
      it "returns http unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
      it "The user does not exist" do
        expect(@json_response['message']).to eq("You can't see other users' lists")
      end
    end
  end
end