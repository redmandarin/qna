FactoryGirl.define do
  factory :comment do
    association :commentable, factory: :question
    body "Comment text"
    user
  end

end
