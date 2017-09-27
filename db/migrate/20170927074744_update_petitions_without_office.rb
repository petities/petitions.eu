class UpdatePetitionsWithoutOffice < ActiveRecord::Migration
  def up
    Petition.where(office_id: nil).update_all(office_id: Office.default_office.id)
  end
end
