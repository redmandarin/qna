FactoryGirl.define do
  factory :question do
    title "MyString"
    body "MyText"
    user
  end

  factory :invalid_question, class: Question do 
    title nil
    body nil
  end

  factory :question_with_file, class: Question do
    title "Some title"
    body "Some body"
    user

    after(:build) do |question, eval|
        question.attachments << FactoryGirl.build(:attachment, attachmentable: question)
    end
  end
end
