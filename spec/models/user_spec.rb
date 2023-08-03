require "rails_helper"

RSpec.describe User, type: :model do
  let(:normal_user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }
  let(:verified_user) { create(:user, verified_at: Time.now) }
  let(:banned_user) { create(:user, disabled_at: Time.now) }

  context "User class" do
    context "Constants" do
      it { expect(VALID_EMAIL_REGEX).to eq(/\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i) }
    end

    describe "Module Inclusions" do
      it {
        expect(User.ancestors).to include(TokenHandler)
      }
    end

    context "Inheritance" do
      it { expect(User.superclass).to eq ApplicationRecord }
    end
  end

  context "enum" do
    it "has a default role of user" do
      expect(normal_user.user?).to be_truthy
    end

    it "admin has a admin role" do
      expect(admin_user.admin?).to be_truthy
    end

    it do
      should define_enum_for(:role).
               with_values([:user, :admin])
    end
  end

  context "Validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_confirmation_of(:password) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:password) }

    context "password set" do
      before { allow(subject).to receive(:password_set?).and_return(true) }
      it { is_expected.to validate_length_of(:password).is_at_least(6) }
    end

    context "password not set" do
      before { allow(subject).to receive(:password_set?).and_return(false) }
      it { is_expected.not_to validate_length_of(:password).is_at_least(6) }
    end

    context "email" do
      it "should have valid email format" do
        normal_user.email = "tushar"
        expect(normal_user.save).to be_falsey
        normal_user.email = "tushar@quora"
        expect(normal_user.save).to be_falsey
        normal_user.email = "@quora-clone.com"
        expect(normal_user.save).to be_falsey
        normal_user.email = "tushar@quora-clone.com"
        expect(normal_user.save).to be_truthy
      end
    end
  end

  context "Associations" do
    it { is_expected.to have_many(:questions).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:answers).dependent(:nullify) }
    it { is_expected.to have_many(:comments).dependent(:nullify) }
    it { is_expected.to have_many(:credits).dependent(:destroy) }
    it { is_expected.to have_many(:orders).dependent(:destroy) }
    it { is_expected.to have_many(:followed_users).class_name("Follow").with_foreign_key(:follower_id) }
    it { is_expected.to have_many(:following_users).class_name("Follow").with_foreign_key(:followee_id) }
    it { is_expected.to have_many(:followers).through(:following_users) }
    it { is_expected.to have_many(:followees).through(:followed_users) }
    it { is_expected.to have_secure_password }
    it { is_expected.to have_one_attached(:profile_picture) }
  end

  context "Callbacks" do
    it { is_expected.to callback(:send_confirmation_email).after(:commit) }
    it { is_expected.to callback(:downcase_email).before(:save) }
    it { is_expected.to callback(:generate_email_confirm_token).before(:create) }
    it { is_expected.to callback(:add_verification_credits).before(:update).if(:verified_at_changed?) }
    it { is_expected.to callback(:generate_auth_token).before(:update).if(:verified_at_changed?) }
  end

  context "Instance Methods" do
    describe "#verified?" do
      context "when user is not verified" do
        it { expect(normal_user.verified?).to be_falsey }
      end
      context "when user is verified" do
        it { expect(verified_user.verified?).to be_truthy }
      end
    end

    describe "#banned?" do
      context "when user is not banned" do
        it { expect(normal_user.banned?).to be_falsey }
      end
      context "when user is banned" do
        it { expect(banned_user.banned?).to be_truthy }
      end
    end

    describe "#email_activate" do
      context "when email is not activated" do
        it { expect(normal_user.email_confirm_token).not_to be_nil }
        it { expect(normal_user.verified_at).to be_nil }
      end
      context "when email is activated" do
        before { normal_user.email_activate }
        it { expect(normal_user.email_confirm_token).to be_nil }
        it { expect(normal_user.verified_at).not_to be_nil }
      end
    end

    describe "#send_password_reset" do
      context "before reset" do
        it { expect(normal_user.password_reset_sent_at).to be_nil }
        it { expect(normal_user.password_reset_token).to be_nil }
      end

      context "after password reset sent" do
        before { normal_user.send_password_reset }
        it { expect(normal_user.password_reset_sent_at).not_to be_nil }
        it { expect(normal_user.password_reset_token).not_to be_nil }
      end
    end
    context "Follow" do
      let(:followee) { create(:user) }
      describe "#follow" do
        context "Follow successful" do
          before { normal_user.follow(followee) }
          it { expect(normal_user.followees).to include(followee) }
          it { expect(followee.followers).to include(normal_user) }
          it { expect(normal_user.followed_users).to include(Follow.find_by(followee_id: followee.id)) }
          it { expect(followee.following_users).to include(Follow.find_by(follower_id: normal_user.id)) }
        end
      end

      describe "#unfollow" do
        context "unfollow successful" do
          before { normal_user.unfollow(followee) }
          it { expect(normal_user.followees).not_to include(followee) }

          it { expect(normal_user.followed_users).not_to include(Follow.find_by(followee_id: followee.id)) }
        end
      end
    end
  end
end
