require 'active_support/concern'

module FindPetition extend ActiveSupport::Concern

  # Use callbacks to share common setup or constraints between actions.
  #
  def find_petition
    Globalize.locale = params[:locale] || I18n.locale

    # find petition by slug name subdomain, id, friendly_name
    if params[:slug]
      @petition = Petition.find_by_cached_slug(params[:slug])
    elsif params[:subdomain]
      @petition = Petition.find_by_subdomain(params[:subdomain])
    elsif params[:petition_id]
      @petition = Petition.find(params[:petition_id])
    else
      begin
        # find by friendly url
        @petition = Petition.friendly.find(params[:id])
      rescue
        # find in all locales petition that matches..
        @petition = Petition.joins(:translations)
                    .where('petition_translations.slug like ?', "%#{params[:id]}%").first
      end
    end
  end

end
