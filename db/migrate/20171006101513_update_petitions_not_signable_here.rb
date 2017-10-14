class UpdatePetitionsNotSignableHere < ActiveRecord::Migration
  def up
    Petition.where(status: 'not_signable_here').update_all(status: 'sign_elsewhere')
  end
end
