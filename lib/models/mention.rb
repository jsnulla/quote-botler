class Mention < ActiveRecord::Base
  validates :target_id, uniqueness: { scope: :tweet_id }

  belongs_to :tweet
  belongs_to :target
end
