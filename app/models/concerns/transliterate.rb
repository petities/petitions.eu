# Transliterate attributes before validation
module Transliterate
  extend ActiveSupport::Concern

  included do
    class_attribute :transliterated_attributes, instance_writer: false
    before_validation :transliterate
  end

  class_methods do
    def transliterate(*fields)
      self.transliterated_attributes = fields
    end
  end

  private

  def transliterate
    transliterated_attributes.each do |field|
      value = send(field)
      send("#{field}=", ActiveSupport::Inflector.transliterate(value)) if value
    end
  end
end
