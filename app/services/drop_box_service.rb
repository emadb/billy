class DropBoxService

  def upload file_name, file
    client = Dropbox::API::Client.new(:token  => ENV['DROPBOX_TOKEN'], :secret => ENV['DROPBOX_SECRET'])
    client.upload ENV['DROPBOX_FOLDER'] + file_name, File.read(file)
  end
end