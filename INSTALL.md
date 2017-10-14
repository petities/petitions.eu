# Getting started

The steps below provide some first steps for using the code.

* Make sure you have the  version of Ruby installed. You can find the used version in `.ruby-version`.
* Use `bundle install` to install all gems.
* Create a `config/database.yml` file. When your database is MySQL, you can use the provided `config/database.yml.example` file.
* Create a `config/secrets.yml` file. You can use the provided `config/secrets.yml.example`
* Use `rake db:setup` to create the databases, load the schema and seed database (`db:setup` does `db:create`, `db:schema:load`, `db:seed`)
* Install redis and start the service.
 
