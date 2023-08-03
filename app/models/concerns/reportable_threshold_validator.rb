class ReportableThresholdValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.reports.count >= REPORTS_THRESHOLD
      record.errors.add record.class.to_s, I18n.t("not publishable")
    end
  end
end
