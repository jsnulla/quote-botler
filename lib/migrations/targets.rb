class CreateTargetsTable < ActiveRecord::Migration[6.0]
  def up
    unless ActiveRecord::Base.connection.table_exists?(:targets)
      create_table :targets do |table|
        table.bigint :user_id
        table.string :current_handle
        table.string :nickname
        table.timestamps
      end

      friends = [
        { user_id: 578319427, nickname: 'wugs' },
        { user_id: 2734152769, nickname: 'jairus' },
        { user_id: 168659239, nickname: 'papa p' },
        { user_id: 1240240834336833536, nickname: 'edgelord' },
      ]
      friends.each{|friend| Target.create(friend) }
    end
  end

  def down
    if ActiveRecord::Base.connection.table_exists?(:targets)
      drop_table :targets
    end
  end
end
