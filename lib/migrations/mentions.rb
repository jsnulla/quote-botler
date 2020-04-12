class CreateMentionsTable < ActiveRecord::Migration[6.0]
  def up
    unless ActiveRecord::Base.connection.table_exists?(:mentions)
      create_table :mentions do |table|
        table.bigint :tweet_id
        table.bigint :target_id
        table.timestamps
      end
    end
  end

  def down
    if ActiveRecord::Base.connection.table_exists?(:mentions)
      drop_table :mentions
    end
  end
end
