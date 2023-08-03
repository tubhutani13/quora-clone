class CreateCredits < ActiveRecord::Migration[7.0]
  def change
    create_table :credits do |t|
      t.integer :amount
      t.integer :description
      t.references :user, null: false, foreign_key: true
      t.references :creditable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
