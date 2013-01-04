class DropBoxService

  def upload file_name, file
    client = Dropbox::API::Client.new :token => ENV['dropbox_token'], :secret => ENV['dropbox_secret']
    client.upload file_name, File.read(file)
  end
end