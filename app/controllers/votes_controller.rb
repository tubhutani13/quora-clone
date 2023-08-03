class VotesController < ApplicationController
  before_action :set_voteable

  def upvote
    @voteable.upvote(current_user.id)
    render json: { total_votes: @voteable.net_votes, type: 'upvote'}
  end

  def downvote
    @voteable.downvote(current_user.id)
    render json: { total_votes: @voteable.net_votes, type: 'downvote' }
  end

  private def set_voteable
    @voteable = params[:voteable_type].constantize.find(params[:voteable_id])
  end
end
