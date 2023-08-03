class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :code
      t.decimal :amount, scale:2, precision: 7
      t.integer :status
      t.references :user, null: false, foreign_key: true
      t.references :credit_pack, null: false, foreign_key: true

      t.timestamps
    end
  end
end
