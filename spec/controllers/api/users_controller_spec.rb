require "spec_helper"
require 'jwt'

RSpec.describe UsersController, type: :controller do
  describe "GET #show" do
    context "when valid" do
      before do
        get :show, format: :json, params: { id: @user.id }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      
      it "JSON body response contains expected user attributes" do
        expect(json.keys).to match_array(["id", "email", "full_name", "photo_path", "lists"])
      end
      
      it "JSON body response contains expected user id" do
        expect(json['id']).to eq(@user.id)
      end

      it "JSON body response contains expected user email" do
        expect(json['email']).to eq(@user.email)
      end

      it "JSON body response contains expected user full_name" do
        expect(json['full_name']).to eq(@user.full_name)
      end

      it "JSON body response contains expected user photo_path" do
        expect(json['photo_path']).to eq(@user.photo_path)
      end
    end
    
    context "when invalid" do
      context  "when the user does not authenticate", :nil_token do
        before do
          get :show, format: :json ,params: { id: @user.id }
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
          request.headers["AUTHORIZATION"] = "Bearer #{@token}"
          get :show, format: :json, params: { id: "false_id" }
        end
        
        it "returns http not found" do
          expect(response).to have_http_status(:not_found)
        end
        
        it "The user does not exist" do
          expect(json['message']).to eq('The user does not exist')
        end
      end

      context "when the user's token does not match the user to display" do
        before do
          get :show, format: :json, params: { id: @user1.id }
        end

        it "returns http unauthorized" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "The user cannot modify other users" do
          expect(json['message']).to eq("You cannot see other users profile")
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

  describe "PUT #update" do
    context "when valid" do
      before do
        request.headers["AUTHORIZATION"] = "Bearer #{@token}"
        @full_name = "New full_name"
        put :update, format: :json, params: { id: @user.id, full_name: @full_name }
      end

      it "returns http no content" do
        expect(response).to have_http_status(:no_content)
      end

      it "The user has been updated successfully" do
        expect(json['message']).to eq('Updated user')
      end

      it "JSON body response contains expected user full_name" do
        expect(json['data']['full_name']).to eq(@full_name)
      end
    end

    context "when invalid" do
      context  "when the user does not authenticate", :nil_token do
        before do
          put :update, format: :json, params: { id: @user.id }
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
          request.headers["AUTHORIZATION"] = "Bearer #{@token}"
          put :update, format: :json, params: { id: "False id"}
        end
        
        it "returns http unauthorized" do
          expect(response).to have_http_status(:not_found)
        end
  
        it "The user does not exist" do
          expect(json['message']).to eq('The user does not exist')
        end
      end
      
      context "when the user's token does not match the user to display" do
        before do
          request.headers["AUTHORIZATION"] = "Bearer #{@token}"
          get :update, format: :json, params: { id: @user1.id}
        end

        it "returns http unauthorized" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "The user cannot modify other users" do
          expect(json['message']).to eq("You cannot modify other users")
        end
      end
    end
  end
  
  describe "DELETE #destroy" do
    context "when valid" do
      before do 
        request.headers["AUTHORIZATION"] = "Bearer #{@token}"
        delete :destroy, format: :json, params: { id: @user.id }
      end

      it "The user has been deleted successfully" do
        expect(json['message']).to eq('The user has been deleted')
      end

      it "The user could not be found because it was removed" do
        get :show, format: :json, params: { id: @user.id }
        expect(json['errors']).to eq("Couldn't find User with 'id'=#{@user.id}")
      end
    end

    context "when invalid" do
      context  "when the user does not authenticate", :nil_token do
        before do 
          delete :destroy, format: :json, params: { id: @user.id }
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
          request.headers["AUTHORIZATION"] = "Bearer #{@token}"
          delete :destroy, format: :json, params: { id: "False_id" }
        end
        
        it "returns http not found" do
          expect(response).to have_http_status(:not_found)
        end
        
        it "The user does not exist" do
          expect(json['message']).to eq('The user does not exist')
        end
      end

      context "when the user's token does not match the user to display" do
        before do
          request.headers["AUTHORIZATION"] = "Bearer #{@token}"
          delete :destroy, format: :json, params: { id: @user1.id }
        end

        it "returns http unauthorized" do
          expect(response).to have_http_status(:unauthorized)
        end
        
        it "The user cannot modify other users" do
          expect(json['message']).to eq("You cannot delete other users")
        end
      end
    end
  end

  describe "Photo path" do
    describe "PUT #add_photo_path" do
      context "when valid" do
        before do
          request.headers["AUTHORIZATION"] = "Bearer #{@token}"
          @photo_path = "www.photo_path.com"
          put :update_photo_path, format: :json, params: { id: @user.id, photo_path: @photo_path }
        end
  
        it "returns http no content" do
          expect(response).to have_http_status(:ok)
        end
  
        it "The photo path has been updated correctly" do
          expect(json['message']).to eq('The photo path has been updated correctly')
        end
  
        it "JSON body response contains expected user photo path" do
          expect(json['photo_path']).to eq(@photo_path)
        end
      end
      
      context "when invalid" do
        context "when the user pass other params" do
          before do
            request.headers["AUTHORIZATION"] = "Bearer #{@token}"
            put :update_photo_path, format: :json, params: { id: @user.id, full_name: "Joel Alayon" }
          end

          it "The user must pass the correct parameters" do
            expect(json['message']).to eq("You must pass the parameter 'photo_path' to update it")
          end
        end

        context  "when the user does not authenticate", :nil_token do
          before do 
            put :update_photo_path, format: :json, params: { id: @user.id}
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
            request.headers["AUTHORIZATION"] = "Bearer #{@token}"
            put :update_photo_path, format: :json, params: { id: "False id" }
          end
          
          it "returns http not found" do
            expect(response).to have_http_status(:not_found)
          end
          
          it "The user does not exist" do
            expect(json['message']).to eq('The user does not exist')
          end
        end
  
        context "when the user's token does not match the user to display" do
          before do
            request.headers["AUTHORIZATION"] = "Bearer #{@token}"
            put :update_photo_path, format: :json, params: { id: @user1.id }
          end
  
          it "returns http unauthorized" do
            expect(response).to have_http_status(:unauthorized)
          end
          
          it "The user cannot modify other users" do
            expect(json['message']).to eq("You cannot modify other users' photo path")
          end
        end
      end
    end

    describe "DELETE #remove_photo_path" do
      context "when valid" do
        before do
          request.headers["AUTHORIZATION"] = "Bearer #{@token}"
          delete :remove_photo_path, format: :json, params: { id: @user.id }
        end
  
        it "returns http no content" do
          expect(response).to have_http_status(:ok)
        end
  
        it "The photo path has been removed" do
          expect(json['message']).to eq('The photo path has been removed from this user')
        end
      end

      context "when invalid" do
        context  "when the user does not authenticate", :nil_token do
          before do 
            delete :remove_photo_path, format: :json, params: { id: @user.id }
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
            request.headers["AUTHORIZATION"] = "Bearer #{@token}"
            delete :remove_photo_path, format: :json, params: { id: "False id" }
          end
          
          it "returns http not found" do
            expect(response).to have_http_status(:not_found)
          end
          
          it "The user does not exist" do
            expect(json['message']).to eq('The user does not exist')
          end
        end
  
        context "when the user's token does not match the user to display" do
          before do
            request.headers["AUTHORIZATION"] = "Bearer #{@token}"
            delete :remove_photo_path, format: :json, params: { id: @user1.id }
          end
  
          it "returns http unauthorized" do
            expect(response).to have_http_status(:unauthorized)
          end
          
          it "The user cannot modify other users" do
            expect(json['message']).to eq("You cannot delete other users' photo path")
          end
        end
        
        context "when the photo path has already been removed" do
          before do
            @user = create(:user, photo_path: "")
            @token = JsonWebToken.encode(user_id: @user.id)
            request.headers["AUTHORIZATION"] = "Bearer #{@token}"
            delete :remove_photo_path, format: :json, params: { id: @user.id }
          end
  
          it "returns http unauthorized" do
            expect(response).to have_http_status(:unprocessable_entity)
          end
          
          it "The photo path has already been removed" do
            expect(json['message']).to eq("The photo path has already been removed from this user")
          end
        end
      end
    end
  end
end
