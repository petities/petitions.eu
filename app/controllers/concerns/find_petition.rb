module FindPetition
  extend ActiveSupport::Concern

  def find_petition
    Globalize.locale = params[:locale] || I18n.locale

    @petition = if subdomain?
                  find_by_subdomain
                elsif params[:petition_id]
                  find_by_id(params[:petition_id])
                else
                  find_by_id(params[:id])
                end
  end

  private

  def find_by_subdomain
    Petition.find_by_subdomain(request.subdomain)
  end

  def find_by_id(id)
    Petition.friendly.find(id)
  end
end
