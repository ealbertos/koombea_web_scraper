FactoryBot.define do
  factory :website do
    url { Faker::Internet.url }
    title { Faker::Lorem.sentence }
    total_links { 0 }
    status { :pending }
    user
  end
end
