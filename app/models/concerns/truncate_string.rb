# Truncate strings for attributes to 255 characters before validation
module TruncateString
  extend ActiveSupport::Concern

  included do
    class_attribute :truncate_strings, instance_writer: false
    before_validation :truncate_string
  end

  class_methods do
    def truncate_string(*fields)
      self.truncate_strings = fields
    end
  end

  private

  def truncate_string
    truncate_strings.each do |field|
      value = read_attribute(field)
      write_attribute(field, value.truncate(255)) if value
    end
  end
end
