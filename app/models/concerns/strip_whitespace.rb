# Strip whitespace from ActiveRecord attributes before validation
module StripWhitespace
  extend ActiveSupport::Concern

  included do
    class_attribute :stripped_attributes, instance_writer: false
    before_validation :strip_whitespace
  end

  class_methods do
    def strip_whitespace(*fields)
      self.stripped_attributes = fields
    end
  end

  private

  def strip_whitespace
    stripped_attributes.each do |field|
      value = read_attribute(field)
      write_attribute(field, value.strip) if value
    end
  end
end
