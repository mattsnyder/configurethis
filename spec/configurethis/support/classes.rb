%w[
  conventional_path
  missing_configuration
  namespaced_conventional_path
  nested_config
  override_path
  riak_config
 ].each do |file|
  require File.join("configurethis", "support", "classes", file)
end
