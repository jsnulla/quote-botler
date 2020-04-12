require 'mysql2'
require 'active_record'

ActiveRecord::Base.default_timezone = :local
ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
ActiveRecord::Base.logger.level = App.dev? ? :debug : :warn
ActiveRecord::Base.establish_connection(
  adapter: 'mysql2',
  host: ENV.fetch('DB_HOST', 'localhost'),
  username: ENV.fetch('DB_USER', 'root'),
  password: ENV.fetch('DB_PASS', 'p@$$w0rd'),
  database: ENV.fetch('DB_NAME', 'quote_botler'),
  encoding: 'utf8mb4'
)
