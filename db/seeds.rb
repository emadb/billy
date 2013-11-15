# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create(email: 'demo@codiceplastico.com', password: 'demo', admin: true, name: 'demopwd')
Setting.create(key: 'fiscal_year', value: 2013)

Setting.create(key: 'iva', value: 0.22)
Setting.create(key: 'iban', value: 'define_your_iban')
Setting.create(key: 'dropbox_enabled', value: false)
Setting.create(key: 'dropbox_app_key', value: 'app_key')
Setting.create(key: 'dropbox_app_secret', value: 'app_secret')
Setting.create(key: 'dropbox_token', value: 'token')
Setting.create(key: 'dropbox_secret', value: 'secret')
Setting.create(key: 'dropbox_folder', value: '/')
Setting.create(key: 'dropbox_app_mode', value: 'dropbox')
Setting.create(key: 'footer', value: '<div>put your footer here</div>')