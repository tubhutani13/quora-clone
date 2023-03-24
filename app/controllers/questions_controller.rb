class QuestionsController < ApplicationController
  before_action :set_question, only: [:edit, :update, :destroy, :show]

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build(question_params)
    respond_to do |format|
      if @question.publish_question(params[:publish])
        format.html { redirect_to question_url(@question), notice: params[:publish] ? t("question_publish_success") : t("question_draft_success") }
        format.json { render :show, status: :created, location: @question }
      else
        flash[:error] = t("error")
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @question.update_question(question_params, params[:publish])
      redirect_to question_path, notice: params[:publish] ? t("question_publish_success") : t("question_draft_success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @question.destroy
      redirect_to user_path(current_user), notice: t("question_delete_success")
    else
      render :show, status: :unprocessable_entity
    end
  end

  def show
  end

  def index
    @questions = @q.result
    @topics = Topic.all
  end

  private

  def question_params
    params.require(:question).permit(:title, :content, :pdf_attachment, :permalink, topic_list: [])
  end

  def set_question
    @question = Question.find_by(permalink: params[:permalink])
  end
end
