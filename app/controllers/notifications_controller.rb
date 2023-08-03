class NotificationsController < ApplicationController
  before_action :set_notifications
  skip_before_action :verify_authenticity_token, only:[:mark_read]

  def count
    @count = @notifications.count
    render json: { status: 200, unread_count: @count }
  end

  def show
    render json: @notifications.limit(5), each_serializer: NotificationsUserSerializer
  end

  def mark_read
    if @notifications.update_all(read_at: Time.now)
      render json: { status: 200 }
    else
      flash[:error] = "could not mark notifications as read"
      render json: { status: :unprocessable_entity }
    end
  end

  private def set_notifications
    @notifications = current_user.notifications_users.unread
  end
end
