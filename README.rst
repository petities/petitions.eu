README
======

.. image:: https://codeclimate.com/github/petities/petitions.eu/badges/gpa.svg
   :target: https://codeclimate.com/github/petities/petitions.eu
   :alt: Code Climate

.. image:: https://codeclimate.com/github/petities/petitions.eu/badges/coverage.svg
   :target: https://codeclimate.com/github/petities/petitions.eu/coverage
   :alt: Test Coverage

.. image:: https://codeclimate.com/github/petities/petitions.eu/badges/issue_count.svg
   :target: https://codeclimate.com/github/petities/petitions.eu
   :alt: Issue Count

.. image:: https://semaphoreci.com/api/v1/projects/f50e2ded-59d5-452d-bf8d-abd3e7dd9648/645425/shields_badge.svg
   :target: https://semaphoreci.com/petities/petitions-eu
   :alt: Build Status

* Ruby version 2.2.3

* System dependencies

    bundle install

* Configuration


* Database creation

  Create a database.yml in you config folder

* Database initialization

    rake db:migrate

    rake db:seed

* How to run the test suite

    rake test

* Services (job queues, cache servers, search engines, etc.)

    sidekiq

    redis

* Deployment instructions

* I18n updates

Find out which translation keys are missing

    I18n-tasks missing

Add the missing translation keys

    I18n-tasks add-mising

Find out which translation keys are unused

    I18n-tasks unused

I don't know what this does..

    I18n-tasks remove-unused
