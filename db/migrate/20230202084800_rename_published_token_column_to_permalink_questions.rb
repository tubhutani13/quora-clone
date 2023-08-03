class RenamePublishedTokenColumnToPermalinkQuestions < ActiveRecord::Migration[7.0]
  def change
    rename_column :questions, :published_token, :permalink
  end
end
