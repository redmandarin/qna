FactoryGirl.define do
  factory :question do
    title "MyString"
    body "MyText"
    user_id 1
  end

  factory :invalid_question, class: Question do 
    title nil
    body nil

  end

end
