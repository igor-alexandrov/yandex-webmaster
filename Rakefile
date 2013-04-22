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
require './lib/webmaster/version.rb'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "webmaster"
  gem.homepage = "http://github.com/igor-alexandrov/webmaster"
  gem.license = "MIT"
  gem.summary = %Q{Ruby wrapper for Yandex.Webmaster API}
  gem.email = "igor.alexandrov@gmail.com"
  gem.authors = ["Igor Alexandrov"]
  gem.version = Webmaster::Version::STRING
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :install

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|  
  version = Webmaster::Version::STRING

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "webmaster #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
