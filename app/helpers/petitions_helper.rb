module PetitionsHelper
  def petition_share_url(petition)
    return "https://#{petition.subdomain}.petities.nl" if petition.subdomain.present?

    petition_url(petition)
  end

  def petition_status_options
    Petition::POSSIBLE_STATES.map do |status|
      [t("petition.states.#{status}"), status]
    end
  end
end
