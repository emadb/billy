WICKED_PDF = {
  #:wkhtmltopdf => '/usr/local/bin/wkhtmltopdf',
  #:layout => "pdf.html",
  :exe_path => Rails.root.join('bin', 'wkhtmltopdf-amd64').to_s
}

WickedPdf.config[:exe_path] = WICKED_PDF[:exe_path]
