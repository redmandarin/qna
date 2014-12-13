FactoryGirl.define do
  factory :answer do
    body "MyText"
user_id 1
question_id 1
  end

  factory :invalid_answer, class: Answer do
    body nil
    user_id nil
    question_id nil
  end

end
