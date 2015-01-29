class Api::V1::ProfilesController < Api::V1::BaseController
  # 0bfe524fd2395c6857661dba998797f266ef233fb2985c34c7153a79e10c1661

  def me
    respond_with current_resource_owner
  end

  def index
    respond_with(@users = User.where(["id != ?", current_resource_owner.id]))
  end
end