class PetitionPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    return false unless user
    user.has_role?(:admin) ||
      user.has_role?(:admin, petition) ||
      user.has_role?(:admin, petition.office)
  end

  def special_update?
    update?
  end

  def finalize?
    update?
  end

  def export?
    user && (user.has_role?(:admin, petition) || user.has_role?(:admin))
  end

  def invalid_attributes
    remove = []

    return remove if user.has_role?(:admin)

    remove += petitioner_fields if user.has_role?(:admin, petition.office)

    # if signature count is below a dozen, then the petition can still be edited
    return remove if petition.get_count.to_i < 12

    unless user.has_role?(:admin, petition.office)
      unless petition.concept? || petition.is_staging?
        remove += [:name, :subdomain, :initiators, :statement, :request]
      end
    end

    remove
  end

  private

  def petition
    record
  end

  def petitioner_fields
    [
      :petitioner_organisation, :petitioner_birth_date,
      :petitioner_birth_city, :petitioner_name,
      :petitioner_address, :petitioner_postalcode, :petitioner_city,
      :petitioner_email, :petitioner_telephone
    ]
  end
end
