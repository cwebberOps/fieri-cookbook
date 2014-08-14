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
  home '/srv/fieri'
  comment 'Fieri'
  shell '/bin/bash'
end

directory '/srv/fieri/shared' do
  user 'fieri'
  group 'fieri'
  mode 0755
  recursive true
end

directory '/srv/fieri/shared/log' do
  user 'fieri'
  group 'fieri'
  mode 0755
  recursive true
end

template '/srv/fieri/shared/unicorn.rb' do
  source 'unicorn.rb.erb'
end

deploy_revision '/srv/fieri' do
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
  end

  notifies :restart, 'service[unicorn]'
  notifies :restart, 'service[sidekiq]'
end
