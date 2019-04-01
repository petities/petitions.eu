class UpdatePolicy < ApplicationPolicy
  def create?
    return false unless user
    return true if petition_update?

    user.has_role?(:admin)
  end

  def edit?
    create?
  end

  def update?
    create?
  end

  def destroy?
    update?
  end

  private

  def petition_update?
    return false unless petition

    user.has_role?(:admin, petition) ||
      user.has_role?(:admin, petition.office)
  end

  def petition
    record.petition
  end
end
