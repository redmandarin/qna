require "rails_helper"

RSpec.describe AnswerMailer, :type => :mailer do
  describe "notify" do
    let(:question) { create(:question) }
    let(:mail) { AnswerMailer.notify(question.id) }

    it "renders the headers" do
      expect(mail.subject).to eq("Notify")
      expect(mail.to).to eq([question.user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
