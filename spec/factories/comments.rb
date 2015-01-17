FactoryGirl.define do
  factory :comment do
    association :commentable, factory: [:question]
    body "Comment text"
    user
  end

  factory :comment_of_answer, class: Answer do
    association :commentable, factory: [:answer]
    body "Comment text"
    user
  end

end
