require './lib/boot'

namespace :db do
  mysql = App::Client.Mysql
  db_name = ENV.fetch('DB_NAME', 'quote_botler')
  charset = 'CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci'

  task :reset do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
  end

  task :setup do
    Rake::Task["db:create"].invoke
    Rake::Task["migrate:up"].invoke
  end

  task :create do
    mysql.query("CREATE DATABASE IF NOT EXISTS #{db_name} #{charset}")
    puts "CREATED DATABASE: #{db_name}"
  end

  task :drop do
    pp mysql.query("DROP DATABASE IF EXISTS #{db_name}")
    puts "DROPPED DATABASE: #{db_name}"
  end
end

namespace :migrate do
  migration_classes = Dir["./lib/migrations/*.rb"].map do |file|
    require file
    file_name = file.split('/').last.gsub('.rb', '')
    "Create#{file_name.camelize}Table".constantize
  end

  task :reset do
    Rake::Task["migrate:down"].invoke
    Rake::Task["migrate:up"].invoke
  end

  task :up do
    migration_classes.each{|migration| migration.migrate(:up)}
  end

  task :down do
    migration_classes.each{|migration| migration.migrate(:down)}
  end
end
