class DropBoxService
  def upload file_name, file

    # TODO: This config should not be here. Move to the initializer.
    Dropbox::API::Config.app_key = AppSettings.dropbox_app_key
    Dropbox::API::Config.app_secret = AppSettings.dropbox_app_secret 
    Dropbox::API::Config.mode = AppSettings.dropbox_app_mode

    client = Dropbox::API::Client.new(:token  => AppSettings.dropbox_token, :secret => AppSettings.dropbox_secret)
    client.upload AppSettings.dropbox_folder + file_name, file
  end
end