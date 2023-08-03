class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :transaction_id, null: false, index: { unique: true }
      t.decimal :amount, null: false
      t.string :payment_method, null: false
      t.string :payment_status, null: false
      t.string :reason
      t.string :status
      t.references :order, null: false, foreign_key: true
      t.timestamps
    end
  end
end
