FactoryGirl.define do
  factory :book do
    name     { Faker::Name.name }
    summary  { Faker::Lorem.sentence }
    quantity { Faker::Number.number(2) }
    price { Faker::Number.number(2) }
  end
end