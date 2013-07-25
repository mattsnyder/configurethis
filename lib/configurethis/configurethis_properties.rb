class ConfigurethisProperties

  def self.root_path=(path)
    @@root_path = path
  end

  def self.root_path
    @@root_path
  end

end
