# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create(email: 'admin@codiceplastico.com', password: 'administrator', admin: true, name: 'admin')

UserActivityType.create(description: 'sviluppo')
UserActivityType.create(description: 'analisi')
UserActivityType.create(description: 'meeting')
UserActivityType.create(description: 'formazione')
UserActivityType.create(description: 'consulenza')
UserActivityType.create(description: 'ferie')
UserActivityType.create(description: 'malattia')
