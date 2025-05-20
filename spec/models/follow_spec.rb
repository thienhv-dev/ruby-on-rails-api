require 'rails_helper'

RSpec.describe Follow, type: :model do
  it "is valid with valid attributes" do
    follow = FactoryBot.build(:follow)
    expect(follow).to be_valid
  end
end