require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do 
    @user = create(:user)
    @token = JsonWebToken.encode(user_id: @user.id)
  end
  describe "GET #index" do
    before do
      request.headers["AUTHORIZATION"] = "Bearer #{@token}"
      get :index, format: :json
      @json_response = JSON.parse(response.body)
    end
    context "when valid" do 
      context "when all the users are obtained correctly" do
        it "returns http success" do
          expect(response).to have_http_status(:success)
        end
        
        it "JSON body response contains expected user attributes" do
          expect(@json_response.first.keys).to match_array(["id", "email", "full_name", "photo_path"])
        end
        
        it "response with JSON body containing expected user email" do
          expect(@json_response.first['email']).to eq('test@gmail.com')
        end

        it "response with JSON body containing expected user full_name" do
          expect(@json_response.first['full_name']).to eq('Joel Alayon')
        end

        it "response with JSON body containing expected user photo_path" do
          expect(@json_response.first['photo_path']).to eq('www.url.com')
        end
      end
    end
    context "when invalid" do
      context "when it returns the unexpected users" do

        it "JSON body response contains invalid movies attributes" do
          expect(@json_response.first.keys).to_not match_array(["invalidKey","invalidKey", "invalidKey", "invalidKey"])
        end
        
        it "response with JSON body containing unexpected user email" do
          expect(@json_response.first['email']).to_not eq('Invalid email')
        end

        it "response with JSON body containing unexpected user full_name" do
          expect(@json_response.first['full_name']).to_not eq('Invalid full_name')
        end

        it "response with JSON body containing unexpected user photo_path" do
          expect(@json_response.first['photo_path']).to_not eq('Invalid photo_path')
        end
      end
    end
  end

  describe "GET #show" do
    before do
      request.headers["AUTHORIZATION"] = "Bearer #{@token}"
      get :show, format: :json ,params: { id: @user.id }
      @json_response = JSON.parse(response.body)
    end
    context "when valid" do
      context "when it returns the expected user" do
        it "returns http success" do
          expect(response).to have_http_status(:success)
        end
        
        it "JSON body response contains expected user attributes" do
          expect(@json_response.keys).to match_array(["id", "email", "full_name", "photo_path"])
        end
        
        it "response with JSON body containing expected user email" do
          expect(@json_response['email']).to eq('test@gmail.com')
        end

        it "response with JSON body containing expected user full_name" do
          expect(@json_response['full_name']).to eq('Joel Alayon')
        end

        it "response with JSON body containing expected user photo_path" do
          expect(@json_response['photo_path']).to eq('www.url.com')
        end
      end
    end
    context "when invalid" do
      context "when it returns the unexpected movie" do
        
        it "JSON body response contains invalid movie attributes" do
          expect(@json_response.keys).to_not match_array(["invalidKey","invalidKey", "invalidKey", "invalidKey"])
        end
        
        it "response with JSON body containing unexpected user email" do
          expect(@json_response['email']).to_not eq('Invalid email')
        end

        it "response with JSON body containing unexpected user full_name" do
          expect(@json_response['full_name']).to_not eq('Invalid full_name')
        end

        it "response with JSON body containing unexpected user photo_path" do
          expect(@json_response['photo_path']).to_not eq('Invalid photo_path')
        end
      end
    end
  end
  describe "POST #Create" do
    before do 
      @created_user = {"status"=>"SUCCES", "message"=>"Created user", "data"=>{"id"=>307, "email"=>"joelito@gmail.com", "full_name"=>"Joelito Alayon"}}
      @not_created_user = {"status"=>"ERROR", "message"=>"User not created"}
      @taken_email = {"status"=>"ERROR", "message"=>"User not created", "data"=>{"email"=>["has already been taken", "has already been taken"]}}
      @short_password = {"status"=>"ERROR", "message"=>"User not created", "data"=>{"password"=>["is too short (minimum is 6 characters)", "is too short (minimum is 6 characters)"]}}
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
        expect(@taken_email['data']['email']).to eq(["has already been taken", "has already been taken"])
      end
      it "The user password is too short" do
        expect(@short_password['data']['password']).to eq(["is too short (minimum is 6 characters)", "is too short (minimum is 6 characters)"])
      end
    end
  end
  describe "DELETE #destroy" do
    before do 
      request.headers["AUTHORIZATION"] = "Bearer #{@token}"
      delete :destroy, format: :json, params: { id: @user.id }
      @json_response = JSON.parse(response.body)
    end
    context "when valid" do
      it "The user has been deleted successfully" do
        expect(@json_response['status']).to eq('SUCCES')
      end
    end
    context "when invalid" do
      it "The user has not been deleted" do
        expect(@json_response['status']).to_not eq('ERROR')
      end
    end
  end
end