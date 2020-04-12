class Tweet < ActiveRecord::Base
  SIGNATURE = '🤖 JayBot 🤖'
  validates_length_of :message, { in: 8..250 }
  validates_uniqueness_of :message_hash, case_sensitive: true

  before_validation do
    hash_message
  end

  has_many :mentions
  has_many :targets, through: :mentions, dependent: :destroy

  def mention_handles
    self.targets.map(&:current_handle)
  end

  def post
    processed_message = <<-TEXT
      #{self.message}

      #{construct_mentions}
      #{SIGNATURE}
    TEXT
    processed_message.gsub!(/^#{processed_message.scan(/^[ \t]+(?=\S)/).min}/, '')

    if processed_message.size <= 280
      if App.dev?
        puts "\e[1m\e[32m << TWEETS ARE PRINTED OUT IN DEV MODE, BUT WILL BE POSTED ON PRODUCTION >> \e[0m"
        pp processed_message
      else
        App::Client.Twitter.update(processed_message)
      end
    else
      raise "Tweet is too long: #{processed_message.size}/280 characters"
    end
  end

  private
  def hash_message
    md5 = Digest::MD5.new
    md5 << self.message
    self.message_hash = md5.hexdigest
  end

  def construct_mentions
    mentions_string = self.targets.map do |target|
      "@#{target.current_handle}"
    end
    mentions_string.join(' ')
  end
end
