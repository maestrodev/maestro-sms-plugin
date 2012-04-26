# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
# 
#  http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require 'rake/clean'
require 'rspec/core/rake_task'
require 'zippy'

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

def add_file( zippyfile, dst_dir, f )
  puts "Writing #{f} at #{dst_dir}"
  zippyfile["#{dst_dir}/#{f}"] = File.open(f)
end

def add_dir( zippyfile, dst_dir, d )
  glob = "#{d}/**/*"
  FileList.new( glob ).each { |f|
    if (File.file?(f))
      add_file zippyfile, dst_dir, f
    end
  }
end

desc "Package plugin zip"
task :package do
  Zippy.create 'maestro-sms-plugin-1.1-SNAPSHOT.zip' do |z|
    add_dir z, '.', 'vendor'
    add_file z, '.', 'manifest.json'
    add_file z, '.', 'README.md'
    add_file z, '.', 'src/smsified_worker.rb'
  end
end

# Rake::PackageTask.new("maestro-sms-plugin", "1.0-SNAPSHOT") do |p|
#     p.need_zip = true
#     p.package_files.include("src/**/*.rb")
#     p.package_files.include("vendor/cache/*.gem")
#     p.package_files.include("manifest.json", "README.md")
# end
