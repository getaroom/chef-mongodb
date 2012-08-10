remote_file File.join(Chef::Config['file_cache_path'], node['mongodb']['package_file']) do
  source node['mongodb']['url']
  action :create_if_missing
end

dpkg_package File.join(Chef::Config['file_cache_path'], node['mongodb']['package_file'])

needs_mongo_gem = (node.recipes.include?("mongodb::replicaset") or node.recipes.include?("mongodb::mongos"))

if needs_mongo_gem
  # install the mongo ruby gem at compile time to make it globally available
  gem_package 'mongo' do
    action :nothing
  end.run_action(:install)
  Gem.clear_paths
end

if node.recipes.include?("mongodb::default") or node.recipes.include?("mongodb")
  # configure default instance
  mongodb_instance "mongodb" do
    mongodb_type "mongod"
    port         node['mongodb']['port']
    logpath      node['mongodb']['logpath']
    dbpath       node['mongodb']['dbpath']
    enable_rest  node['mongodb']['enable_rest']
  end
end