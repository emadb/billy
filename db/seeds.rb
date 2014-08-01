# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create(email: 'demo@codiceplastico.com', password: 'demopwd', admin: true, name: 'demopwd')
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
Setting.create(key: 's3_enabled', value: false)
Setting.create(key: 's3_bucket', value: 's3_bucket')
Setting.create(key: 's3_access_key_id', value: 's3_access_key_id')
Setting.create(key: 's3_secret_access_key', value: 's3_secret_access_key')

UserActivityType.create(description: 'lavorativa', isWorking: true)
UserActivityType.create(description: 'ferie', isWorking: false)
UserActivityType.create(description: 'malattia', isWorking: false)

ExpenseType.create(description: 'rimborso km')
ExpenseType.create(description: 'alloggio')
ExpenseType.create(description: 'treno')
ExpenseType.create(description: 'vitto')
