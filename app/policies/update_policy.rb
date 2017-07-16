class UpdatePolicy < ApplicationPolicy
  def create?
    return false unless user
    return true if petition_update?
    user.has_role?(:admin) || user.has_role?(:admin, record)
  end

  def edit?
    create?
  end

  def update?
    create?
  end

  private

  def petition_update?
    return false unless record.petition_id
    petition = Petition.find(record.petition_id)
    user.has_role?(:admin, petition) ||
      user.has_role?(:admin, petition.office)
  end
end
