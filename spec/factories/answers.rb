FactoryGirl.define do
  factory :answer do
    body "My answer text"
    user
    question
    rating 0
    best false
  end

  factory :invalid_answer, class: Answer do
    body nil
    user_id nil
    question_id nil
  end

  factory :answer_with_file, class: Answer do
    body "My answer text"
    user
    question

    after(:build) do |answer, eval|
      answer.attachments << FactoryGirl.build(:attachment, attachmentable: answer)
    end
  end

end
