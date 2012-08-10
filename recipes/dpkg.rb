remote_file File.join(Chef::Config['file_cache_path'], File.basename(node['mongodb']['package_file'])) do
  source node['mongodb']['url']
  action :create_if_missing
end

dpkg_package File.join(Chef::Config[:file_cache_path], File.basename(node['mongodb']['package_file']))
