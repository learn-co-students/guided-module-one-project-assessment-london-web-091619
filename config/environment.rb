require "bundler/setup"
Bundler.require

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "db/gelato.db",
)

 ActiveRecord::Base.logger = nil

require_all "lib"
