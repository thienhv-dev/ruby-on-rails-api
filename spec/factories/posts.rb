FactoryBot.define do
  factory :post do
    title { "Sample Title" }
    content { "This is a sample post." }
    association :user
  end
end