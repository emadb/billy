class AppSettings
  @@keys = []
  def self.init
    # Load settings from database
    settings = Setting.all
    settings.each do |s|
      self.class.send :define_method, s.key, proc{ s.value }
      @@keys << s.key
    end
  end

  def self.method_missing (method, *args, &block)
    if @@keys.include?(method)
      return nil
    end
  end
end