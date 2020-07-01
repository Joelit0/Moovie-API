require 'rails_helper'

RSpec.describe ListsController, type: :controller do
  before do
    @user = create(:user)
    @user1 = create(:user)
    @list = create(:list, user_id: @user.id)
    @list1 = create(:list, user_id: @user1.id)
    @token = JsonWebToken.encode(user_id: @user.id)
  end
  
  describe "GET #index" do
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
        expect(@json_response.first['name']).to eq(@list.name)
      end
      
      it "JSON body response contains expected list description" do
        expect(@json_response.first['description']).to eq(@list.description)
      end

      it "JSON body response contains expected list id" do
        expect(@json_response.first['id']).to eq(@list.id)
      end

      it "JSON body response contains expected list state" do
        expect(@json_response.first['public']).to eq(@list.public)
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
        expect(@json_response['message']).to eq("You cannot see other users' lists")
      end
    end
  end
  
  describe "GET #show" do
    context "when valid" do
      before do
        request.headers["AUTHORIZATION"] = "Bearer #{@token}"
        get :show, format: :json, params: { id: @list.id }
        @json_response = JSON.parse(response.body)
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "JSON body response contains expected lists attributes" do
        expect(@json_response.keys).to match_array(["created_at", "description", "id", "name", "public", "updated_at", "user_id", "movies"])
      end
      
      it "JSON body response contains expected list name" do
        expect(@json_response['name']).to eq(@list.name)
      end
      
      it "JSON body response contains expected list description" do
        expect(@json_response['description']).to eq(@list.description)
      end

      it "JSON body response contains expected list id" do
        expect(@json_response['id']).to eq(@list.id)
      end

      it "JSON body response contains expected list state" do
        expect(@json_response['public']).to eq(@list.public)
      end

      it "JSON body response contains user id of expected list" do
        expect(@json_response['user_id']).to eq(@user.id)
      end
    end
    context "when invalid" do
      context "when the user does not authenticate" do
        before do
          get :show, format: :json, params: { id: @user.id }
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
    
    context "when the list does not exist" do
      before do
        request.headers["AUTHORIZATION"] = "Bearer #{@token}"
        get :show, format: :json, params: { id: "False id" }
        @json_response = JSON.parse(response.body)
      end
      
      it "returns http unauthorized" do
        expect(response).to have_http_status(:not_found)
      end

      it "The user does not exist" do
        expect(@json_response['message']).to eq('The list does not exist')
      end
    end

    context "when the user's token does not match the user to display" do
      before do
        request.headers["AUTHORIZATION"] = "Bearer #{@token}"
        get :show, format: :json, params: { id: @list1.id }
        @json_response = JSON.parse(response.body)
      end
      it "returns http unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
      it "The user does not exist" do
        expect(@json_response['message']).to eq("You cannot see other users' lists")
      end
    end
  end
  describe "POST #create" do
    before do
      @created_list = { "message" => "Created List", "data" => { "id" => 9, "name" => "Create list", "description" => "This is my list", "public" => false, "user_id" => 1, "created_at" => "2020-07-01T22:01:58.137Z", "updated_at" => "2020-07-01T22:01:58.137Z" }}
      @description_blank = { "message" => "List not created", "data" => { "description" => ["can't be blank"] }}
      @name_blank = { "message" => "List not created", "data" => { "name" => ["can't be blank"] }}
      @public_blank = { "message" => "List not created", "data" => { "public" => ["is not included in the list","is reserved"] }}
    end

    context "when valid" do
      it "The list has been created successfully" do
        expect(@created_list['message']).to eq('Created List')
      end
    end

    context "when invalid" do
      it "The list has not been created successfully" do
        expect(@description_blank['message']).to eq('List not created')
      end
      
      context "when blank fields" do
        it "The list can't be blank" do
          expect(@description_blank['data']['description']).to eq(["can't be blank"])
        end

        it "The list name can't be blank" do
          expect(@name_blank['data']['name']).to eq(["can't be blank"])
        end
        
        it "The list state can't be blank" do
          expect(@public_blank['data']['public']).to eq(["is not included in the list","is reserved"])
        end
      end
    end
  end
end