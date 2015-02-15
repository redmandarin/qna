require 'rails_helper'

describe SearchHelper do
  describe '#link_for_search' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let(:comment_of_question) { create(:comment, commentable: question) }
    let(:comment_of_answer) { create(:comment, commentable: answer ) }

    it 'returns link to self if question' do
      expect(link_for_search(question)).to eq(link_to(question.title, question))
    end

    it 'returns link to parent if answer' do
      expect(link_for_search(answer)).to eq(link_to(question.title, question))
    end

    it 'returns link to parent if comment of question' do
      expect(link_for_search(comment_of_question)).to eq(link_to(question.title, question))
    end

    it 'returns link to parent if comment of answer' do
      expect(link_for_search(comment_of_answer)).to eq(link_to(question.title, question))
    end
  end
end