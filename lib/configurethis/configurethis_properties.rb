class ConfigurethisProperties

  def self.root_path=(path)
    @@root_path = path
  end

  def self.root_path
    @@root_path ||= 'config'
  end

  def self.defaults
    @@root_path = nil
  end

end
