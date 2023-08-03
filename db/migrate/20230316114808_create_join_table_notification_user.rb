class CreateJoinTableNotificationUser < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :notifications do |t|
      t.boolean :sent
      t.datetime :read_at
      t.index [:user_id, :notification_id]
      t.index [:notification_id, :user_id]
    end
  end
end
