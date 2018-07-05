FactoryGirl.define do
  factory :user_book do
    association :book
    association :user
  end
end
