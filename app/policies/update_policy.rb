class UpdatePolicy < ApplicationPolicy
  def create?
    return false unless user
    return true if petition_update?
    user.has_role?(:admin) || user.has_role?(:admin, record)
  end

  def edit?
    # allow edit view on petition.
    return false unless user
    return true if petition_update?
    user.has_role?(:admin) || user.has_role?(:admin, record)
  end

  def update?
    return false unless user
    return true if petition_update?
    user.has_role?(:admin) || user.has_role?(:admin, record)
    # allow updates on petition..?
    # user.has_role? :admin or user.has_role? :admin, record
  end

  def petition_update?
    return false unless record.petition_id
    petition = Petition.find(record.petition_id)
    user.has_role?([:admin, :manager], petition)
  end
end
