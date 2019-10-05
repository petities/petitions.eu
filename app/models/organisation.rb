class Organisation < ActiveRecord::Base
  scope :district,       -> { where(kind: 'district') }
  scope :collective,     -> { where(kind: 'collective') }
  scope :water_county,   -> { where(kind: 'water_county') }
  scope :counsil,        -> { where(kind: 'counsil') }
  scope :government,     -> { where(kind: 'government') }
  scope :european_union, -> { where(kind: 'european_union') }
  scope :parliament,     -> { where(kind: 'parliament') }
  scope :plusregion,     -> { where(kind: 'plusregion') }

  scope :visible,        -> { where(visible: true) }

  has_one :office
end
