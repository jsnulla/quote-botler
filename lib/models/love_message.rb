class LoveMessage < ActiveRecord::Base
  validates_length_of :message, { in: 8..250 }
  validates_uniqueness_of :message, case_sensitive: false
end
