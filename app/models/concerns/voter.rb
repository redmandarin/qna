module Voter
  extend ActiveSupport::Concern

  def vote(value)
    self.rating += value.to_i
    self.user.rating += value.to_i
    self.user.save
    self.save
  end
end