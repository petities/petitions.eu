source 'http://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
gem 'rails-i18n'

gem 'globalize', '~> 5.0.0'
gem 'globalize-versioning'
# friendly slugs..
gem 'friendly_id'
gem 'friendly_id-globalize'

# Use sqlite3 as the database for Active Record

gem 'sqlite3', group: :development
gem 'mysql2', '~> 0.3.18'

# legacy utf 8 issues..
gem 'utf8-cleaner'
gem 'rack-utf8_sanitizer'

# make jquery work with turbolinks..
gem 'jquery-turbolinks'

# authentication
gem 'devise'
gem 'devise-encryptable'
gem 'devise-i18n'
gem 'rolify'

# date validation

gem 'validates_timeliness'

# roles mamangement
gem 'pundit'

# cache
gem 'dalli'

# minimal template language
gem 'slim'

# markdown stuff
gem 'redcarpet'

# pdf format templates
gem 'prawn'
gem 'prawn-table'
gem 'prawnto'

# will_paginate
gem 'will_paginate'
# gem 'will_paginate-bootstrap'
gem 'will-paginate-i18n'
#

# gem 'i18n_generators'
gem 'i18n-tasks'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

gem 'sprockets'
gem 'sprockets-rails'

# image file upload made easypeasy
gem 'paperclip'

# execute jobs on the side..
gem 'sidekiq'
gem 'sinatra', require: nil # sidekiq/web uses sinatra

# create periodic tasks in your project
gem 'whenever', require: false

# have some real time stats of our app
gem 'redis_analytics' #:git => 'git@github.com:saturnine/redis_analytics.git'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# general settings management
gem 'config', github: 'railsconfig/config'

gem 'activeadmin', github: 'activeadmin'

# bootstrap
# gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'http_accept_language'
gem 'i18n-country-translations'
gem 'countries'
gem 'country_select'

# Validate e-mail addresses
gem 'email_validator', '~> 1.6'

gem 'has_secure_token', '~> 1.0'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
group :production do
  gem 'unicorn'
end

# Track errors in production
gem 'rollbar', '~> 2.5.0'

# Use CodeClimate and Semaphore CI for testing
gem "codeclimate-test-reporter", group: :test, require: nil

group :development do
  gem 'capistrano-rails', '~> 1.1.1'
  gem 'capistrano-rbenv', '~> 2.0.3'
  gem 'capistrano-bundler', '~> 1.1.4'
  gem 'capistrano3-unicorn', '~> 0.2.1'
  gem 'capistrano-sidekiq', '~> 0.5.4'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  # create fake data
  gem 'faker'
  gem 'mailcatcher'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
