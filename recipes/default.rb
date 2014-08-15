#
# Cookbook Name:: resource-manager
# Recipe:: default
#
# Copyright (C) 2014
#
#
#
include_recipe "mongodb"
include_recipe "supervisor"

package 'git'
package 'python-setuptools'

python_pip "Flask"
python_pip "Flask-Bootstrap"
python_pip "eve"
python_pip "PrettyTable"
python_pip "requests"

install_path = '/root/DeploymentManager'
resource_manager_path = "#{install_path}/resource_manager"
execute 'git clone https://github.com/eucalyptus/DeploymentManager' do
   cwd '/root/'
   not_if "ls #{install_path}"
end

execute 'git pull' do
   cwd install_path
end

execute 'python setup.py install' do
   cwd install_path
end

supervisor_service "resource-manager-api" do
  action [:enable, :start]
  command "#{resource_manager_path}/server.py"
  autostart true
  user "root"
end
