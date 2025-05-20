require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }

  subject do
    described_class.new(
      title: 'Sample Title',
      content: 'This is a sample post.',
      user: user
    )
  end

  describe 'validations' do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is invalid without title" do
      subject.title = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:title]).to include("can't be blank")
    end

    it "is invalid when title is too long" do
      subject.title = 'a' * 101
      expect(subject).not_to be_valid
      expect(subject.errors[:title]).to include("is too long (maximum is 100 characters)")
    end

    it "is invalid without content" do
      subject.content = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:content]).to include("can't be blank")
    end

    it "is invalid when content is too long" do
      subject.content = 'a' * 5001
      expect(subject).not_to be_valid
      expect(subject.errors[:content]).to include("is too long (maximum is 5000 characters)")
    end

    it "is invalid without user" do
      subject.user = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:user]).to include("must exist")
    end
  end

  describe '.ransackable_attributes' do
    it 'includes the correct attributes' do
      expected_attributes = %w[title content created_at updated_at user_id email]
      expect(Post.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe '.ransackable_associations' do
    it 'includes the correct associations' do
      expect(Post.ransackable_associations).to include("user")
    end
  end
end
