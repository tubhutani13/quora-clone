class AddCreditsColumnToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :credits_count, :integer, default: 0
  end
end
