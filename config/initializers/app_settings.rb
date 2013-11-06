class AppSettings
  #TODO: move these settings to the database
  def self.iva
    0.22
  end
  def self.iban
    ENV['IBAN'] || 'define_your_iban_in_the_env'
  end
  def self.dropbox_enabled?
    ENV['DROPBOX_ENABLED'] || false
  end

  def self.dropbox_app_key
    ENV['DROPBOX_APP_KEY']
  end

  def self.dropbox_app_secret
    ENV['DROPBOX_APP_SECRET']
  end

  def self.dropbox_token
    ENV['DROPBOX_TOKEN']
  end

  def self.dropbox_secret
    ENV['DROPBOX_SECRET']
  end

  def self.dropbox_folder
    ENV['DROPBOX_FOLDER'] || '/'
  end

  def self.dropbox_app_mode
    ENV['DROPBOX_APP_MODE'] || 'dropbox'
  end

  def self.footer
    ENV['FOOTER'] || '<div>put your footer here</div>'
  end

  # Load settings from database
  settings = Setting.all
  settings.each do |s|
    self.class.send :define_method, s.key, proc{ s.value }
  end
end