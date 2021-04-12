source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.11.3'
gem 'rails-i18n'

gem 'paper_trail'
gem 'globalize', '~> 5.3.0'
gem 'globalize-versioning'
# friendly slugs..
gem 'friendly_id'
gem 'friendly_id-globalize'

gem 'mysql2', '0.5.2'

# legacy utf8 issues..
gem 'rack-utf8_sanitizer'
gem 'utf8-cleaner'

# authentication
gem 'devise', '~> 4.7'
gem 'devise-i18n'
gem 'rolify'

# date validation
gem 'validates_timeliness'

# roles management
gem 'pundit'

# minimal template language
gem 'slim'

# markdown stuff
gem 'redcarpet'

# pdf format templates
gem 'prawn', '~> 2.4'
gem 'prawn-table'
gem 'prawnto'

gem 'kaminari'
gem 'kaminari-i18n'

gem 'bourbon'
gem 'simple_form'

# Search.
# gem 'elasticsearch-model', '~> 5.0', '>= 5.0.1'
# gem 'elasticsearch-rails', '~> 5.0', '>= 5.0.1'

# gem 'i18n_generators'
gem 'i18n-tasks'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 4.2'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2', '>= 4.2.2'
gem 'font-awesome-rails'

gem 'sprockets'
gem 'sprockets-rails'

# image file upload made easypeasy
gem 'paperclip', '~> 6.1'

# execute jobs on the side..
gem 'sidekiq'
gem 'sinatra', require: nil # sidekiq/web uses sinatra

# create periodic tasks in your project
gem 'whenever', require: false

gem 'redis-rails'
# have some real time stats of our app
gem 'redis_analytics' #:git => 'git@github.com:saturnine/redis_analytics.git'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.9'

gem 'activeadmin', '~> 1.4'

# bootstrap
# gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'i18n-country-translations'
gem 'countries'
gem 'country_select'

# Validate e-mail addresses
gem 'email_validator', '~> 1.6', require: 'email_validator/strict'

gem 'has_secure_token', '~> 1.0'

group :production do
  gem 'unicorn'
end

# Track errors in production
gem 'newrelic_rpm', '~> 6.15'
gem 'rollbar', '~> 3.1'

gem 'invisible_captcha', '~> 1.0'
gem 'rack-attack', '~> 6.2'

# Use CodeClimate and Semaphore CI for testing
gem 'codeclimate-test-reporter', group: :test, require: nil

group :development do
  gem 'capistrano-bundler', '~> 1.6.0'
  gem 'capistrano-maintenance', '~> 1.2', require: false
  gem 'capistrano-rails', '~> 1.6'
  gem 'capistrano-rbenv', '~> 2.2'
  gem 'capistrano-sidekiq', '~> 1.0'
  gem 'capistrano3-unicorn', '~> 0.2.1'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.3'

  gem 'rack-mini-profiler'

  # For call-stack profiling flamegraphs (requires Ruby MRI 2.0.0+)
  gem 'fast_stack'    # For Ruby MRI 2.0
  gem 'flamegraph'
  gem 'stackprof'     # For Ruby MRI 2.1+
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger
  # console
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'byebug'
  gem 'quiet_assets'

  gem 'mocha'

  # create fake data
  gem 'faker'

  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'
end

