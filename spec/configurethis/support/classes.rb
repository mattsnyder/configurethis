%w[
  conventional_path
  namespaced_conventional_path
  override_path
  riak_config
 ].each do |file|
  require File.join("configurethis", "support", "classes", file)
end
