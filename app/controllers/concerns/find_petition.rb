module FindPetition
  extend ActiveSupport::Concern

  def find_petition
    Globalize.locale = params[:locale] || I18n.locale

    @petition = if subdomain?
                  find_with_subdomain
                else
                  find_with_id
                end
  end

  private

  def find_with_subdomain
    Petition.find_by!(subdomain: request.subdomain)
  end

  def find_with_id
    petition_id = [params[:petition_id], params[:id]].detect(&:present?)
    Petition.friendly.find(petition_id)
  end
end
