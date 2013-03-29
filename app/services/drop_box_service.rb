class DropBoxService

  def upload file_name, file
    client = Dropbox::API::Client.new(:token  => ENV['DROPBOX_TOKEN'], :secret => ENV['DROPBOX_SECRET'])
    client.upload Scrooge::Application.config.invoice_folder + file_name, File.read(file)
  end
end