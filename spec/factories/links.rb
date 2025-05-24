FactoryBot.define do
  factory :link do
    url { Faker::Internet.url }
    name { Faker::Lorem.sentence }
    website
  end
end

