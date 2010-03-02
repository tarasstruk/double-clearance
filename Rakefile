# encoding: utf-8

require 'rake'
require 'rake/testtask'
require 'cucumber/rake/task'

namespace :test do
  Rake::TestTask.new(:basic => ["cleanup", "features"]) do |task|
    task.libs << "lib"
    task.libs << "test"
    task.pattern = "test/**/*_test.rb"
    task.verbose = false
  end
end

desc "Removes the app"
task :cleanup do
  `rm -rf test_app`
end

desc "What can this thing do?"
task :features do
  `rails test_app && cd test_app && rake db:migrate db:test:prepare`
end

desc "Run the test suite"
task :default => ['cleanup', 'features']

require 'jeweler'

Jeweler::Tasks.new do |gem|
  gem.name        = "clearance"
  gem.summary     = "Rails authentication with email & password."
  gem.description = "Rails authentication with email & password."
  gem.email       = "support@thoughtbot.com"
  gem.homepage    = "http://github.com/thoughtbot/clearance"
  gem.authors     = ["Dan Croak", "Mike Burns", "Jason Morrison",
                     "Joe Ferris", "Eugene Bolshakov", "Nick Quaranto",
                     "Josh Nichols", "Mike Breen", "Marcel Görner",
                     "Bence Nagy", "Ben Mabey", "Eloy Duran",
                     "Tim Pope", "Mihai Anca", "Mark Cornick",
                     "Shay Arnett", "Jon Yurek", "Chad Pytel"]
  gem.files       = FileList["[A-Z]*", "{app,config,lib,shoulda_macros,rails}/**/*"]
end

Jeweler::GemcutterTasks.new
