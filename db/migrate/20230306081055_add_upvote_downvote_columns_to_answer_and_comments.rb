class AddUpvoteDownvoteColumnsToAnswerAndComments < ActiveRecord::Migration[7.0]
  def change
    add_column :answers, :upvote_count, :integer, default: 0
    add_column :comments, :upvote_count, :integer, default: 0
    add_column :answers, :downvote_count, :integer, default: 0
    add_column :comments, :downvote_count, :integer, default: 0
  end
end
