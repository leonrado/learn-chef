#
# Cookbook:: learn_chef_httpd
# Recipe:: install_web_server
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package 'httpd'

service 'httpd' do
  action [:enable, :start]
end

template '/var/www/html/index.html' do
  source 'index.html.erb'
end

