FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    name "MyVeryName"
    email 
    rating 0
    password "password"
    password_confirmation "password"
  end

end
