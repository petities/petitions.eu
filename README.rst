README
======

* Ruby version 2.2.2

* System dependencies

  bundle install

* Configuration


* Database creation

  create a database.yml in you config folder
  there is an example sqlite database availble.
  link is to be added..

* Database initialization

    rake db:migrate
    rake db:seed

* How to run the test suite

    rake test

* Services (job queues, cache servers, search engines, etc.)

    memcached

* Deployment instructions


Legacy migration db tips
========================

old mysql database contains latin1 and utf8 to fix this
change the database to utf with the following sql

    ALTER DATABASE petities CHARACTER SET utf8 COLLATE utf8_unicode_ci;
    ALTER TABLE newsitems CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;
    ALTER TABLE petitions CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;

the convert lating8 special characters to utf8

    mysqldump --add-drop-table database_name | iconv -f latin1 -t utf8 | mysql database_name

