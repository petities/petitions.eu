# == Schema Information
#
# Table name: organisations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  kind       :string(255)
#  code       :string(5)
#  region     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  visible    :boolean
#

class Organisation < ActiveRecord::Base
  scope :district,       -> { where(kind: 'district') }
  scope :collective,     -> { where(kind: 'collective') }
  scope :water_county,   -> { where(kind: 'water_county') }
  scope :counsil,        -> { where(kind: 'counsil') }
  scope :governement,    -> { where(kind: 'governement') }
  scope :european_union, -> { where(kind: 'european_union') }
  scope :parliament,     -> { where(kind: 'parliament') }
  scope :plusregion,     -> { where(kind: 'plusregion') }

  scope :visible,        -> { where(visible: true) }
end
