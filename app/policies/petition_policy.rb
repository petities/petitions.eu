

class PetitionPolicy < ApplicationPolicy 

  def update?
    # allow updates on petition..?
    # user.admin? or not record.published? or user.is_owner(petition)
    true
  end

end
