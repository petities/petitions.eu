class PetitionPolicy < ApplicationPolicy
  def create?
    true
  end

  def can_edit user, petition
    user.has_role?(:admin) ||
    user.has_role?(:admin, petition) ||
    user.has_role?(:admin, petition.office)
  end

  def edit?
    # allow edit view on petition.
    return false unless user
    can_edit user, record
  end

  def update?
    return false unless user
    can_edit user, record
    # allow updates on petition..?
    # user.has_role? :admin or user.has_role? :admin, record
  end

  def finalize?
    return false unless user
    can_edit user, record
  end

end
