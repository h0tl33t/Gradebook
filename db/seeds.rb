# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Create an admin
Admin.create(first_name: 'Robert', last_name: 'Baratheon', email: 'usurping@gmail.com', password: 'sekretz', password_confirmation: 'sekretz')

#Generate test data.
DataGenerator::Core.new.all #WARNING: Creates a lot of data.  Takes a minute or two.