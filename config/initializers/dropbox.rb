Dropbox::API::Config.app_key    = ENV['dropbox_app_key'] 
Dropbox::API::Config.app_secret =  ENV['dropbox_app_secret']
Dropbox::API::Config.mode       = "sandbox" # if you have a single-directory app or "dropbox" if it has access to the whole dropbox

    