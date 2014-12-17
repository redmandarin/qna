module Authority
  extend ActiveSupport::Concern

  def author?(user)
    self.user == user
  end
end