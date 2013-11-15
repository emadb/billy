class AppSettings
  def self.init
    # Load settings from database
    settings = Setting.all
    settings.each do |s|
      self.class.send :define_method, s.key, proc{ s.value }
    end
  end

  def self.method_missing (method, *args, &block)
  end
end