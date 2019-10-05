class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true

  scopify

  scope :without_resource, -> { where(resource_type: nil, resource_id: nil) }
end
