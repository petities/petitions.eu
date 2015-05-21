

class PetitionPolicy < ApplicationPolicy 

  def create?
    true
  end

  def edit?
    puts 'POLICY??'
    puts 'POLICY??'
    puts 'POLICY??'
    puts 'POLICY??'
    # allow edit view on petition.
    puts @petition
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
    user.has_role? :admin or user.has_role? :admin, record
  end

end
