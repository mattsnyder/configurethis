%w[
  conventional_path
  keys_config
  missing_configuration
  namespaced_conventional_path
  nested_config
  override_path
  rails_app_config
  riak_config
 ].each do |file|
  require File.join("configurethis", "support", "classes", file)
end
