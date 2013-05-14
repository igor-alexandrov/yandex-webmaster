# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
require './lib/yandex-webmaster/version.rb'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "yandex-webmaster"
  gem.homepage = "http://github.com/igor-alexandrov/yandex-webmaster"
  gem.license = "MIT"
  gem.summary = %Q{Ruby wrapper for Yandex.Webmaster API}
  gem.email = "igor.alexandrov@gmail.com"
  gem.authors = ["Igor Alexandrov"]
  gem.version = Yandex::Webmaster::Version::STRING
end
Jeweler::RubygemsDotOrgTasks.new

task :default => :install

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|  
  version = Yandex::Webmaster::Version::STRING

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "yandex-webmaster #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
