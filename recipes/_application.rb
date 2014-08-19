#
# Cookbook Name:: fieri
# Recipe:: application
#
# Copyright 2014 Chef Software, Inc.
#

package 'git'

group 'fieri' do
  system true
end

user 'fieri' do
  gid 'fieri'
  system true
  home node['fieri']['home']
  comment 'Fieri'
  shell '/bin/bash'
end

directory "#{node['fieri']['home']}/shared" do
  user 'fieri'
  group 'fieri'
  mode 0755
  recursive true
end

directory "#{node['fieri']['home']}/log" do
  user 'fieri'
  group 'fieri'
  mode 0755
  recursive true
end

app = data_bag_item(:apps, node['fieri']['data_bag'])

template "#{node['fieri']['home']}/shared/.env.production" do
  variables(app: app)

  user 'fieri'
  group 'fieri'

  notifies :restart, 'service[unicorn]'
  notifies :restart, 'service[sidekiq]'
end

template "#{node['fieri']['home']}/shared/unicorn.rb" do
  source 'unicorn.rb.erb'
end

deploy_revision node['fieri']['home'] do
  repo 'https://github.com/opscode/fieri.git'
  revision 'master'
  user 'fieri'
  group 'fieri'
  migrate false
  symlink_before_migrate.clear
  environment 'RACK_ENV' => 'production'

  before_restart do
    execute 'bundle install' do
      cwd release_path
      command 'bundle install --without test development --path=vendor/bundle'
    end

    link "#{node['fieri']['home']}/current/.env" do
      to "#{node['fieri']['home']}/shared/.env.production"
    end

    link "#{node['fieri']['home']}/current/log" do
      to "#{node['fieri']['home']}/shared/log"
    end
  end

  notifies :restart, 'service[unicorn]'
  notifies :restart, 'service[sidekiq]'
end
