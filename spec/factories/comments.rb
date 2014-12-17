FactoryGirl.define do
  factory :comment do
    body "MyText"
    user
    question
  end

end
