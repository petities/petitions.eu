class PetitionPolicy < ApplicationPolicy 

  def create?
    true
  end

  def edit?
    # allow edit view on petition.
    if not user
      return false
    end
    user.has_role? :admin or user.has_role? :admin, record
  end

  def update?
    if not user
      return false
    end
    user.has_role? :admin or user.has_role? :admin, record
    # allow updates on petition..?
    # user.has_role? :admin or user.has_role? :admin, record
  end

  def finalize?
    return false unless user

    user.has_role? :admin or user.has_role? :admin, record
  end

end
