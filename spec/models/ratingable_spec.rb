require 'rails_helper'

describe Ratingable do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: another_user)}

  it '.best_answer' do
    Ratingable.best_answer(answer)
    expect(another_user.rating).to eq(3)
  end

  describe '.vote' do
    context 'question' do
      it 'gives +2 to author' do
        Ratingable.vote(build(:positive_vote, voteable: question))
        user.reload
        expect(user.rating).to eq(2)
      end

      it 'gives -2 to author' do
        Ratingable.vote(build(:negative_vote, voteable: question))
        user.reload
        expect(user.rating).to eq(-2)
      end
    end

    context 'answer' do
      it 'gives +1 to author' do
        Ratingable.vote(build(:positive_vote, voteable: answer))
        another_user.reload
        expect(another_user.rating).to eq(1)
      end

      it 'gives -1 to author' do
        Ratingable.vote(build(:negative_vote, voteable: answer))
        another_user.reload
        expect(another_user.rating).to eq(-1)
      end
    end
  end

end
