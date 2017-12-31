# Sets I18n.locale to :nl
module TestInDutchHelper
  extend ActiveSupport::Concern

  included do
    setup :set_locale_to_dutch
  end

  private

  def set_locale_to_dutch
    I18n.locale = :nl
  end
end
