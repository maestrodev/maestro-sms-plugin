# Copyright 2011© MaestroDev.  All rights reserved.

require 'rake/clean'
require 'rake/packagetask'
require 'rspec/core/rake_task'

$:.push File.expand_path("../src", __FILE__)

CLEAN.include("maestro-sms-plugin.zip")

task :default => [:bundle, :spec, :package]

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
  t.rspec_opts = "--fail-fast --format p --color"
  # Put spec opts in a file named .rspec in root
end

desc "Get dependencies with Bundler"
task :bundle do
  system "bundle install package"
end

Rake::PackageTask.new("maestro-sms-plugin", "1.0-SNAPSHOT") do |p|
    p.need_zip = true
    p.package_files.include("src/**/*.rb")
    p.package_files.include("vendor/cache/*.gem")
    p.package_files.include("manifest.json", "README.md")
end
