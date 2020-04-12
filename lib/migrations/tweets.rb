class CreateTweetsTable < ActiveRecord::Migration[6.0]
  def up
    unless ActiveRecord::Base.connection.table_exists?(:tweets)
      create_table :tweets do |table|
        table.text    :message
        table.string  :message_hash
        table.json    :data
        table.timestamps
      end
    end
  end

  def down
    if ActiveRecord::Base.connection.table_exists?(:tweets)
      drop_table :tweets
    end
  end
end
