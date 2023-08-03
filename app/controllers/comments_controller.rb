class CommentsController < ApplicationController
  before_action :load_comment, only: [:destroy]
  before_action :set_entity, only: [:create]
  before_action :load_question

  def create
    @comment = @entity.comments.new(comment_params.merge(user: current_user))
    if @comment.save
      redirect_to @question, notice: t("comment_submit_success")
    else
      flash[:error] = t("comment_publish_error")
      render "questions/show", status: :unprocessable_entity
    end
  end

  def destroy
    if @comment.user == current_user
      if @comment.destroy
        redirect_to @question, notice: t("comment_delete_success")
      else
        flash[:error] = t("comment_delete_error")
        render "questions/show", status: :unprocessable_entity
      end
    else
      flash[:error] = t("comment_user_error")
      render "questions/show", status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :body, :commentable_id, :commentable_type)
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def set_entity
    @entity = comment_params[:commentable_type].constantize.find(comment_params[:commentable_id])
  end

  def load_question
    @question = Question.find_by(permalink: params[:question_permalink])
  end
end
