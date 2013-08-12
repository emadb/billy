class DropBoxService
  def upload file_name, file
    client = Dropbox::API::Client.new(:token  => AppSettings.dropbox_token, :secret => AppSettings.dropbox_secret)
    client.upload AppSettings.dropbox_folder + file_name, file
  end
end