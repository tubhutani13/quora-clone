class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.integer :role, default: 0, null: false
      t.datetime :verified_at
      t.string :email_confirm_token
      t.string :password_reset_token
      t.string :password_reset_sent_at

      t.timestamps
    end
  end
end
