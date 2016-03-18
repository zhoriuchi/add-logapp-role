#
# Cookbook Name:: td-agent2
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
cookbook_file "/etc/yum.repos.d/td.repo" do
  owner "root"
  group "root"
  mode  "0664"
  source "/etc/yum.repos.d/td.repo"
end

package "td-agent" do
  action :install
end

service "td-agent" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start]
end
