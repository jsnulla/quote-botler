require 'twitter'
require 'aws-sdk-comprehend'

module App
  module Client
    def self.Mysql
      Mysql2::Client.new(
        host: ENV.fetch('DB_HOST', 'localhost'),
        username: ENV.fetch('DB_USER', 'root'),
        password: ENV.fetch('DB_PASS', 'p@$$w0rd'),
      )
    end

    def self.Twitter
      Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV.fetch('TWITTER_CONSUMER_KEY', 'WRONG_KEY')
        config.consumer_secret     = ENV.fetch('TWITTER_CONSUMER_SECRET', 'WRONG_KEY')
        config.access_token        = ENV.fetch('TWITTER_ACCESS_TOKEN', 'WRONG_KEY')
        config.access_token_secret = ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET', 'WRONG_KEY')
      end
    end

    def self.Comprehend
      Aws::Comprehend::Client.new(region: ENV.fetch('REGION', 'ap-southeast-1'))
    end
  end
end
