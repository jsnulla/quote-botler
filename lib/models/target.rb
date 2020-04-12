class Target < ActiveRecord::Base
  validates_uniqueness_of :user_id, case_sensitive: true

  before_create :update_screen_name
  after_find :update_screen_name

  has_many :mentions
  has_many :tweets, through: :mentions

  private
  def update_screen_name
    user = App::Client.Twitter.user(self.user_id)
    if user
      self.current_handle = user.screen_name if self.current_handle != user.screen_name
    else
      raise "User cannot be found anymore: #{self.inspect}"
    end
  end
end
