module Authority
  extend ActiveSupport::Concern

  def author?(object)
    object.user == self
  end
end