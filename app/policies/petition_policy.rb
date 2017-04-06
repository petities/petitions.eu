class PetitionPolicy < ApplicationPolicy
  def create?
    true
  end

  def can_edit(user, petition)
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

  def special_update?
    return false unless user
    can_edit user, record
  end

  def finalize?
    return false unless user
    can_edit user, record
  end

  def export?
    user && (user.has_role?(:admin, record) || user.has_role?(:admin))
  end

  def invalid_attributes
    petition = record
    remove = []

    return remove if user.has_role?(:admin)

    if user.has_role?(:admin, petition.office)
      remove += [
        :petitioner_organisation,
        :petitioner_birth_date,
        :petitioner_birth_city,
        :petitioner_name,
        :petitioner_address,
        :petitioner_postalcode,
        :petitioner_city,
        :petitioner_email,
        :petitioner_telephone,
      ]
    end

    # if signature count < 100 petition can still be edited
    return remove if petition.get_count.to_i < 100

    unless user.has_role?(:admin, petition.office)
      unless petition.is_draft? or petition.is_staging?
        remove += [:name, :subdomain, :initiators, :statement, :request]
      end
    end

    remove.uniq
  end
end
