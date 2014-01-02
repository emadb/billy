if Rails.env.development?
  wkhtmltopdf_binary = 'wkhtmltopdf'
else
  wkhtmltopdf_binary = 'wkhtmltopdf-amd64'
end

WICKED_PDF = {
  #:wkhtmltopdf => '/usr/local/bin/wkhtmltopdf',
  #:layout => "pdf.html",
  :exe_path => Rails.root.join('bin', wkhtmltopdf_binary).to_s
}

WickedPdf.config[:exe_path] = WICKED_PDF[:exe_path]
