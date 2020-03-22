# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

Office.find_or_create_by(email: 'nederland@petities.nl') do |office|
  office.name = 'Petitieloket Nederland'
  office.hidden = false
end
