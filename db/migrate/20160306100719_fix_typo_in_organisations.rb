class FixTypoInOrganisations < ActiveRecord::Migration
  def change
    Organisation.where(kind: 'governement').update_all(kind: 'government')
  end
end
