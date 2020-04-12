require './lib/boot'

def perform(event:, context:)
  love_message = LoveMessage.all.sample
  targets = Target.where(nickname: ['wugs', 'jairus'])
  success_message = "Sent love to: #{targets.map(&:current_handle)} 💕"

  tweet = Tweet.create(message: love_message.message, targets: targets)
  tweet.post

  {
    statusCode: 200,
    body: success_message
  }
end
