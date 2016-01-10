require 'test_helper'

# Create admin and login to ActiveAdmin
module ActiveAdminHelper
  extend ActiveSupport::Concern

  included do
    setup :login_admin if respond_to?(:setup)
  end

  private

  def login_admin
    @request.env['devise.mapping'] = Devise.mappings[:admin]
    sign_in admin_users(:one)
  end
end
