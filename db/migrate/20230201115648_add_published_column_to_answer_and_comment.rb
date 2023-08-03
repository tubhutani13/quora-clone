class AddPublishedColumnToAnswerAndComment < ActiveRecord::Migration[7.0]
  def change
    tables = [:answers, :comments]

  tables.each do |table_name|
    add_column table_name, :published_at, :datetime
  end
  end
end
