require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do 
    @user = create(:user)
    @user1 = create(:user)
    @token = JsonWebToken.encode(user_id: @user.id)
  end

  describe "GET #show" do
    context "when valid" do
      before do
        request.headers["AUTHORIZATION"] = "Bearer #{@token}"
        get :show, format: :json, params: { id: @user.id }
        @json_response = JSON.parse(response.body)
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      
      it "JSON body response contains expected user attributes" do
        expect(@json_response.keys).to match_array(["id", "email", "full_name","lists"])
      end
      
      it "JSON body response contains expected user email" do
        expect(@json_response['email']).to eq(@user.email)
      end

      it "JSON body response contains expected user full_name" do
        expect(@json_response['full_name']).to eq('Joel Alayon')
      end
      
      it "JSON body response contains expected user full_name" do
        expect(@json_response['lists']).to eq([])
      end
    end
    context "when invalid" do
      context  "when the user does not authenticate" do
        before do
          get :show, format: :json ,params: { id: @user.id }
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
          get :show, format: :json, params: { id: "false_id" }
          @json_response = JSON.parse(response.body)
        end
        
        it "returns http not found" do
          expect(response).to have_http_status(:not_found)
        end
        
        it "The user does not exist" do
          expect(@json_response['message']).to eq('The user does not exist')
        end
      end
      context "when the user's token does not match the user to display" do
        before do
          request.headers["AUTHORIZATION"] = "Bearer #{@token}"
          delete :show, format: :json, params: { id: @user1.id }
          @json_response = JSON.parse(response.body)
        end
        it "returns http unauthorized" do
          expect(response).to have_http_status(:unauthorized)
        end
        it "The user does not exist" do
          expect(@json_response['message']).to eq("You dont can see other users profile")
        end
      end
    end
  end
  describe "POST #Create" do
    before do 
      @created_user = { "message" => "Created user", "data" => { "id"=>307, "email" => "joelito@gmail.com", "full_name" => "Joelito Alayon" } }
      @not_created_user = { "message" => "User not created" }
      @taken_email = { "message" => "User not created", "data" => { "email" => "has already been taken" } }
      @short_password = { "message" => "User not created", "data" => { "password" => "is too short (minimum is 6 characters)" } }
    end
    context "when valid" do
      it "The user has been created successfully" do
        expect(@created_user['message']).to eq('Created user')
      end
    end
    context "when invalid" do
      it "The user has not been created successfully" do
        expect(@not_created_user['message']).to eq('User not created')
      end
      it "The user email has already been taken" do
        expect(@taken_email['data']['email']).to eq("has already been taken")
      end
      it "The user password is too short" do
        expect(@short_password['data']['password']).to eq("is too short (minimum is 6 characters)")
      end
    end
  end
  describe "DELETE #destroy" do
    context "when valid" do
      before do 
        request.headers["AUTHORIZATION"] = "Bearer #{@token}"
        delete :destroy, format: :json, params: { id: @user.id }
        @json_response = JSON.parse(response.body)
      end

      it "The user has been deleted successfully" do
        expect(@json_response['message']).to eq('The user has been deleted')
      end
    end
    context "when invalid" do
      context "when the user does not authenticate" do
        before do 
          delete :destroy, format: :json, params: { id: @user.id }
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
        
      context "when the user cannot be deleted" do
        before do 
          request.headers["AUTHORIZATION"] = "Bearer #{@token}"
          delete :destroy, format: :json, params: { id: "False_id" }
          @json_response = JSON.parse(response.body)
        end
        
        it "returns http not found" do
          expect(response).to have_http_status(:not_found)
        end
        
        it "The user does not exist" do
          expect(@json_response['message']).to eq('The user does not exist')
        end
      end

      context "when the user's token does not match the user to display" do
        before do
          request.headers["AUTHORIZATION"] = "Bearer #{@token}"
          delete :destroy, format: :json, params: { id: @user1.id }
          @json_response = JSON.parse(response.body)
        end
        it "returns http unauthorized" do
          expect(response).to have_http_status(:unauthorized)
        end
        it "The user does not exist" do
          expect(@json_response['message']).to eq("You dont can delete other users")
        end
      end
    end
  end
end