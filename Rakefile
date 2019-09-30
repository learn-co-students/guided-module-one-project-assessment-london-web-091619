require_relative 'config/environment'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
  Article.new({title: "article title", content: "Artifcle content"})
  
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end
