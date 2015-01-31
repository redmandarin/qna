module Voter
  extend ActiveSupport::Concern

  def vote(value)
    self.rating += value.to_i
    self.save
  end
end