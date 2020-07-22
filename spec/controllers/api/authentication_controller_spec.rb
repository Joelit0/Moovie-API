require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  describe "POST #login" do
    context "when valid" do
      before do
        post :login, format: :json, params: { email: @user.email, password: @user.password }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "JSON body response contains the user token attributes" do
        expect(json.keys).to match_array(["token", "exp", "email"])
      end

      it "JSON body response contains the user email" do
        expect(json['email']).to eq(@user.email)
      end
    end

    context "when invalid" do
      context "when the user does not pass parameters or they are incorrect" do
        before do
          post :login, format: :json
        end

        it "returns http unauthorized" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "JSON body response contains unauthorized error" do
          expect(json['error']).to eq("unauthorized")
        end
      end
    end
  end
end