# task runner for ruby , 'rake' in terminal, command will run specific tasks and build certain pieces of code and files
require_relative 'config/environment'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end
  