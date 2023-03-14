require "rails_helper"

RSpec.describe User, type: :model do
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
    let(:normal_user) { create(:user) }
    let(:admin_user) { create(:user, :admin) }
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
        @user = build(:user, email: "tushar")
        expect(@user.save).to be_falsey

        @user = build(:user, email: "tushar@quora")
        expect(@user.save).to be_falsey

        @user = build(:user, email: "@quora-clone.com")
        expect(@user.save).to be_falsey

        @user = build(:user, email: "tushar@quora-clone.com")
        expect(@user.save).to be_truthy
      end
    end
  end

  context 'Associations' do
    it{is_expected.to have_many(:questions).dependent(:restrict_with_error)}
    it{is_expected.to have_many(:answers).dependent(:nullify)}
    it{is_expected.to have_many(:comments).dependent(:nullify)}
    it{is_expected.to have_many(:credits).dependent(:destroy)}
    it{is_expected.to have_many(:orders).dependent(:destroy)}
    it{is_expected.to have_many(:followed_users).class_name('Follow').with_foreign_key(:follower_id)}
    it{is_expected.to have_many(:following_users).class_name('Follow').with_foreign_key(:followee_id)}
    it{is_expected.to have_many(:followers).through(:following_users)}
    it{is_expected.to have_many(:followees).through(:followed_users)}
    it{is_expected.to have_secure_password}
    it{is_expected.to have_one_attached(:profile_picture)}
  end
end
