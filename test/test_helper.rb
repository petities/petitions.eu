require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'user_login_helper'
require 'test_in_dutch_helper'
require 'models/concerns/strip_whitespace'
require 'models/concerns/truncate_string'
require 'models/concerns/transliterate'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ActiveJob::TestHelper
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end
