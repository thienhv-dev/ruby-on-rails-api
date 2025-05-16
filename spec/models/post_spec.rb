require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { Post.new(title: 'Sample Title', content: 'This is a sample post.') }

  describe 'validations' do
    it 'is valid when title and content are present' do
      expect(post).to be_valid
    end

    it 'is invalid without a title' do
      post.title = nil
      expect(post).not_to be_valid
      expect(post.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without content' do
      post.content = nil
      expect(post).not_to be_valid
      expect(post.errors[:content]).to include("can't be blank")
    end
  end
end
