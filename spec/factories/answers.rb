FactoryGirl.define do
  factory :answer do
    body "MyText"
    user
    question
  end

  factory :invalid_answer, class: Answer do
    body nil
    user_id nil
    question_id nil
  end

end
