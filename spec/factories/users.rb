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

  factory :another_user, class: User do
    name "MyName"
    email "email123@mail.com"
    password "another password"
    password_confirmation "password"
    rating 0
  end

end
