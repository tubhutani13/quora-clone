class Admin::AdminsController < Admin::BaseController
  before_action :set_user, only: [:disable_user]
  before_action :set_entity,only: [:disable_entity]

  def show
  end

  def users
    @users = User.all.where.not(id: current_user.id)
  end

  def questions
    @questions = Question.includes(:user).published_questions
  end

  def answers
    @answers = Answer.includes(:user, :question, :rich_text_content).published_answers
  end

  def comments
    @comments = Comment.includes(:user, :commentable).published_comments
  end

  def disable_user
    if params[:disabled]
      disable_time = Time.now
      message = t("user_disabled")
    else
      disable_time = nil
      message = t("user_enabled")
    end

    if @user.update(disabled_at: disable_time)
      redirect_to request.referrer, notice: message
    else
      redirect_to request.referrer, notice: t('error')
    end
  end

  def disable_entity
    if @entity.unpublish
      redirect_to request.referrer,notice: t("entity_disabled", entity: params[:entity_type])
    else
      redirect_to request.referrer, notice: t('error')
    end
  end

  private def set_user
    @user = User.find(params[:user_id])
  end

  private def set_entity
    @entity = params[:entity_type].constantize.find(params[:entity_id])
  end
end
