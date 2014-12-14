FactoryGirl.define do
  factory :user do
    name "MyString"
    email "some@email.com"
    password "password"
  end

  factory :another_user, class: User do
    name "MyName"
    email "another@email.com"
    password "another password"
  end

end
