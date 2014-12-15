FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    name "MyString"
    email 
    password "password"
    password_confirmation "password"
  end

  factory :another_user, class: User do
    name "MyName"
    email email
    password "another password"
  end

end
