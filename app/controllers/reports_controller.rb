class ReportsController < ApplicationController
  before_action :set_reportable

  def new
    @report = Report.new
  end

  def create
    @report = @reportable.reports.build(report_params, user: current_user)
    if @report.save
      redirect_back_or user_path, notice: "Report was successfully Submitted."
    else
        render :new, status: :unprocessable_entity
    end
  end

  private def set_reportable
    @reportable = params[:reportable_type].constantize.find(params[:reportable_id])
  end

  private def report_params
    params.require(:report).permit(:reason)
  end

  private def check_already_reported
    if @report = @reportable.reports.find_by(user_id: current_user.id)
      redirect_to request.referrer, notice: t("already_reported", abuse_report_time: @report.created_at.to_date)
    end
  end
end
