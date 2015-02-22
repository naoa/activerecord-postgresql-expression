require "bundler/gem_tasks"
require 'rake/testtask'

require File.expand_path(File.dirname(__FILE__)) + "/test/config"
require File.expand_path(File.dirname(__FILE__)) + "/test/support/config"

desc 'Run postgresql tests by default'
task :default => :test

desc 'Run postgresql tests'
task :test => :test_postgresql

desc 'Build PostgreSQL test databases'
namespace :db do
  task :create => ['db:postgresql:build']
  task :drop => ['db:postgresql:drop']
end

%w( postgresql ).each do |adapter|
  namespace :test do
    Rake::TestTask.new(adapter => "#{adapter}:env") { |t|
      t.libs << 'test'
      t.test_files = Dir.glob( "test/cases/**/*_test.rb" ).sort

      t.warning = true
      t.verbose = true
    }
  end

  namespace adapter do
    task :test => "test_#{adapter}"

    # Set the connection environment for the adapter
    task(:env) { ENV['ARCONN'] = adapter }
  end

  # Make sure the adapter test evaluates the env setting task
  task "test_#{adapter}" => ["#{adapter}:env", "test:#{adapter}"]
end

namespace :db do
  namespace :postgresql do
    desc 'Build the PostgreSQL test databases'
    task :build do
      config = ARTest.config['connections']['postgresql']
      %x( createdb -U #{config['arunit']['username']} -E UTF8 -T template0 #{config['arunit']['database']} )
      %x( createdb -U #{config['arunit']['username']} -E UTF8 -T template0 #{config['arunit2']['database']} )
    end

    desc 'Drop the PostgreSQL test databases'
    task :drop do
    config = ARTest.config['connections']['postgresql']
      %x( dropdb #{config['arunit']['database']} )
      %x( dropdb #{config['arunit2']['database']} )
    end

    desc 'Rebuild the PostgreSQL test databases'
    task :rebuild => [:drop, :build]
  end
end

task :build_postgresql_databases => 'db:postgresql:build'
task :drop_postgresql_databases => 'db:postgresql:drop'
task :rebuild_postgresql_databases => 'db:postgresql:rebuild'
