class ProfilePolicy < ApplicationPolicy

  def edit?
    # allow edit view on petition.
    return false unless user
    true
  end

end
