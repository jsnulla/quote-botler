require 'rcredstash'
require 'digest'
require 'json'
require 'httparty'
require 'ordinalize_full/integer'

ENV['STAGE'] = ENV.fetch('STAGE', 'dev')
ENV['REGION'] = ENV.fetch('REGION', 'ap-southeast-1')

module App
  def self.dev?
    ENV['STAGE'] == 'dev'
  end

  def self.prod?
    ENV['STAGE'] == 'prod'
  end
end

# load env
keys = [
  'DB_HOST',
  'DB_USER',
  'DB_PASS',
  'DB_NAME',
  'TWITTER_USER_ID',
  'TWITTER_CONSUMER_KEY',
  'TWITTER_CONSUMER_SECRET',
  'TWITTER_ACCESS_TOKEN',
  'TWITTER_ACCESS_TOKEN_SECRET',
  'FAVQS_API_KEY',
]

keys.each do |key|
  ENV[key] = CredStash.get("#{ENV['STAGE']}.quote_botler.#{key}") || 'wrong_key'
end

if App.dev?
  ENV['DB_NAME'] += '_dev'
end

Dir["./lib/initializers/*.rb"].each { |file| require file }
Dir["./lib/models/*.rb"].each { |file| require file }
