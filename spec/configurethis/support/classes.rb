%w[
  override_path
  conventional_path
  namespaced_conventional_path
 ].each do |file|
  require File.join("configurethis", "support", "classes", file)
end
