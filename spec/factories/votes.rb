FactoryGirl.define do
  factory :vote do
    user
    value 1
    association :voteable, factory: [:question]
  end

  factory :positive_vote, class: Vote do
    user
    value 1
    association :voteable, factory: [:question, :answer]
  end

  factory :negative_vote, class: Vote do
    user
    value -1
    association :voteable, factory: [:question, :answer]
  end
end
