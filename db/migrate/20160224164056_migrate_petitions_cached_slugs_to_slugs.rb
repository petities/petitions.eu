class MigratePetitionsCachedSlugsToSlugs < ActiveRecord::Migration
  def up
    PaperTrail.enabled = false

    petitions = Petition.joins(:translations).where(petition_translations: { slug: nil }).where.not(cached_slug: nil)
    petitions.find_each do |petition|
      petition.slug = petition.cached_slug
      petition.save
    end

    PaperTrail.enabled = true
  end
end
