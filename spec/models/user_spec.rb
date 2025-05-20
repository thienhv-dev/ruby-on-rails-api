require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is invalid without name" do
      subject.name = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:name]).to include("can't be blank")
    end

    it "is invalid without email" do
      subject.email = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:email]).to include("can't be blank")
    end

    it "is invalid with duplicate email" do
      create(:user, email: subject.email)
      expect(subject).not_to be_valid
      expect(subject.errors[:email]).to include("has already been taken")
    end

    it "is invalid with short password" do
      subject.password = "123"
      subject.password_confirmation = "123"
      expect(subject).not_to be_valid
      expect(subject.errors[:password]).to include("is too short (minimum is 6 characters)")
    end
  end

  describe "#follow" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it "allows user to follow another user" do
      expect {
        user.follow(other_user)
      }.to change { user.following.count }.by(1)

      expect(user.following).to include(other_user)
    end

    it "does not allow user to follow themselves" do
      expect {
        user.follow(user)
      }.not_to change { user.following.count }
    end
  end

  describe '.ransackable_attributes' do
    it 'returns the list of allowed ransackable attributes' do
      expected_attrs = %w[id name email created_at updated_at]
      expect(User.ransackable_attributes).to eq(expected_attrs)
    end

    it 'accepts an auth_object argument but ignores it by default' do
      expected_attrs = %w[id name email created_at updated_at]
      fake_auth_object = double('AuthObject')
      expect(User.ransackable_attributes(fake_auth_object)).to eq(expected_attrs)
    end
  end
end
