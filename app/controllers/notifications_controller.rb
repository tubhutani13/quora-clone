class NotificationsController < ApplicationController
  before_action :set_notifications

  def count
    @count = @notifications.count
    render json: { status: 200, unread_count: @count }
  end

  def mark_read
    respond_to do |format|
      if @notifications.update_all(read_at: Time.now)
        format.html { redirect_to root_path}
        format.json { render status: 200 }
      else
        flash[:error] = "could not mark notifications as read"
        format.html { redirect_to request.referrer }
        format.json { render status: :unprocessable_entity }
      end
    end
  end

  private def set_notifications
    @notifications = current_user.notifications_users.unread
  end
end
