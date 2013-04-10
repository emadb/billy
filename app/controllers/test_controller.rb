
class TestController < ApplicationController

  def index
    
    @invoice = Invoice.find(17)
    file_name = "#{@invoice.number} - #{@invoice.customer.file_name_template}.pdf"
    full_path = Rails.root.join('tmp', file_name)
  
    pdf = render_to_string(
            :pdf => file_name,
            :template => 'invoices/show.pdf.html.erb',
            :margin => { :bottom => 15 },
            :footer => {
              :content => '<div class="container" style="text-align:center;color:#777777;font-size:12px;font-family: Helvetica Neue,Helvetica"><p><strong>CodicePlastico srl</strong> - www.codiceplastico.com - Tel: +39 030 6595 241</br>P.IVA, CF e Registro Imprese di Brescia 03079830984 Capitale Sociale : Euro 10.000,00 i.v.</p></div>'
            })

    File.open(full_path, 'wb') do |file|
      file << pdf
    end
    
    logger.info '########################'
    logger.info full_path
    logger.info file_name


    client = Dropbox::API::Client.new(:token  => ENV['DROPBOX_TOKEN'], :secret => ENV['DROPBOX_SECRET'])
    logger.info client.ls

    file_content = File.read(full_path)
    
    client.upload file_name, file_content

    #send_file full_path, :type=> "application/pdf", :disposition => 'inline'
  end
end