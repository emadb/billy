ENV['DROPBOX_FOLDER'] ||= 'CodicePlastico/_Fatture/'
ENV['DROPBOX_APP_MODE'] ||= 'dropbox'

Dropbox::API::Config.app_key = ENV["DROPBOX_APP_KEY"]
Dropbox::API::Config.app_secret = ENV["DROPBOX_APP_SECRET"] 
Dropbox::API::Config.mode = ENV['DROPBOX_APP_MODE']
    