require "rails_helper"

RSpec.describe UsersController, type: :request do
  context "when user is not signed in" do
    it "should be redirected to login path" do
      get "/"
      expect(response).to redirect_to(login_path)
    end
  end

  before(:all) do
    @login_user = create(:user, :with_pass_confirmation)
  end

  context "filters" do
    describe "before actions" do
      it { is_expected.to use_before_action(:authorize_user) }
      it { is_expected.to use_before_action(:set_user) }
      it { is_expected.to use_before_action(:set_user_by_email_confirm_token) }
    end
  end

  describe "Inheritance chain" do
    it "is expected to inherit from Admin::BaseController" do
      expect(UsersController.superclass).to eq ApplicationController
    end
  end

  describe "new" do
    def send_request(params = {}, headers = {})
      get "/users/new", params: params, headers: headers
    end

    before do
      send_request
    end

    it "should render new action and render user form" do
      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
      expect(assigns[:user]).to be_kind_of(User)
    end
  end

  context "when user is signed in" do
    before(:each) { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@login_user) }
    describe "show" do
      let(:user) { create(:user) }

      def send_request(user_id, params = {})
        get user_path(id: user_id), params: params
      end

      context "when record not found" do
        before { send_request(User.last.id + 1) }
        it { expect(response).to have_http_status(404) }
      end
    end

    describe "create" do
      def send_request(params = {}, headers = {})
        post "/users", params: params, headers: headers
      end

      context "when record created successfully" do
        def create_params
          { user: { name: "TEST User", email: "new_user@test.com", password: "akaakaaka", password_confirmation: "akaakaaka" } }
        end

        it "should create a new user and send email" do
          expect { send_request(create_params, {}) }.to have_enqueued_mail(UserMailer, :registration_confirmation).once
          expect(response).to have_http_status(302)
          created_user = assigns(:user)
          expect(created_user).to be_kind_of(User)
          expect(User.last.name).to eq(created_user.name)
          expect(response).to redirect_to(root_path)
          expect(flash[:success]).to eq(I18n.t("confirm_email"))
          follow_redirect!
          expect(subject).to render_template("home/index")
          expect(response).to have_http_status 200
          expect(User.last.verified?).to be_falsey
        end
      end

      context "when record can not be created successfully" do
        def create_params
          { user: { name: "", email: "new_user@test.com", password: "akaakaaka", password_confirmation: "akaakaaka" } }
        end

        it "should not create a new user and render new page with all errors" do
          expect { send_request(create_params, {}) }.not_to change { User.count }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template :new
          expect(assigns[:user].errors[:name]).to include("can't be blank")
          expect(flash[:error]).to eq(I18n.t("error"))
        end
      end
    end

    describe "confirm_email" do
      def send_request(email_confirm_token, params = {}, headers = {})
        get confirm_email_user_path(email_confirm_token), params: params, headers: headers
      end

      context "when user is not found" do
        before { send_request("random_email_token") }
        it " should return error and redirect to home page" do
          expect(response).to redirect_to(root_path)
          expect(flash[:error]).to eq("Sorry. User does not exist")
        end
      end

      context "when user is found" do
        context "wnen email activation is successful" do
          before { @user = create(:user, :with_pass_confirmation); send_request(@user.email_confirm_token) }
          it "should  activate the user" do
            verified_user = assigns(:user)
            expect(verified_user.email_confirm_token).to be_nil
            expect(verified_user.verified?).not_to be_nil
            expect(flash[:success]).to eq(I18n.t("email_activated"))
            expect(response).to redirect_to(login_path)
          end
        end

        context "when email activatation is not successful" do
          before { allow_any_instance_of(User).to receive(:email_activate).and_return(nil) }
          before { @user = create(:user, :with_pass_confirmation); send_request(@user.email_confirm_token) }
          it "should nor activate the user" do
            unverified_user = assigns(:user)
            expect(unverified_user.email_confirm_token).not_to be_nil
            expect(unverified_user.verified?).not_to be_nil
            expect(flash[:error]).to eq(I18n.t("error"))
            expect(response).to redirect_to(root_path)
          end
        end
      end
    end

    describe "edit" do
      def send_request(user_id, params = {}, headers = {})
        get edit_user_url(user_id), params: params, headers: headers
      end

      context "when user is not found" do
        before { send_request(User.last.id + 1) }

        it "should render 404 page" do
          expect(response).to have_http_status(404)
        end
      end

      context "when user is found" do
        it "should render edit template" do
          send_request(User.last.id)
          expect(response).to have_http_status(:success)
          expect(response).to render_template :edit
        end
      end
    end

    describe "update" do
      def send_request(user_id, params = {}, headers = {})
        patch user_path(user_id), params: params, headers: headers
      end

      context "when record created successfully" do
        def update_params
          { user: { name: "TEST User update" } }
        end

        before { send_request(@login_user, update_params) }
        it "should create a new user and send email" do
          expect(response).to have_http_status(302)
          updated_user = assigns(:user)
          expect(updated_user.name).to eq("TEST User update")
          expect(response).to redirect_to(user_path(updated_user))
          expect(flash[:notice]).to eq(I18n.t("profile_update_success"))
          follow_redirect!
          expect(subject).to render_template(:show)
          expect(response).to have_http_status 200
          expect(updated_user.name_previously_changed?).to be_truthy
        end
      end

      context "when record can not be created successfully" do
        def update_params
          { user: { name: "" } }
        end

        before { send_request(@login_user, update_params) }
        it "should not create a new user and render new page with all errors" do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template :edit
          expect(assigns[:user].errors[:name]).to include("can't be blank")
        end
      end
    end

    context "following" do

      let(:user_1) { create(:user, :with_pass_confirmation) }
      before { allow(subject).to receive(:current_user).and_return(@login_user) }

      describe "follow" do
        def send_request(user_id, params = {}, headers = {})
          post follow_user_path(user_id), params: params, headers: headers
        end

        context "User followed success" do
          before { send_request(user_1.id) }
          it { expect(flash[:success]).to eq("User followed successfully") }
        end

        context "User Followed error" do
          before { allow_any_instance_of(User).to receive(:follow).and_return(nil) }
          before { send_request(User.last.id) }
          it { expect(flash[:error]).to eq("error in following") }
        end
      end

      describe "unfollow" do
        def send_request(user_id, params = {}, headers = {})
          post unfollow_user_path(user_id)
        end

        before(:each) { @login_user.follow(user_1) }
        context "User unfollowed success" do
          before {send_request(user_1.id) }
          it { expect(flash[:success]).to eq("User unfollowed successfully") }
        end

        context "User unfollowed error" do
          before { allow_any_instance_of(User).to receive(:unfollow).and_return(nil) }
          before { send_request(User.last.id) }
          it { expect(flash[:error]).to eq("error in unfollowing") }
        end
      end
    end
  end
end
