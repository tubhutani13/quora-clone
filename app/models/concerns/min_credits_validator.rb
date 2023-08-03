class MinCreditsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.user.credits_count < 1
      record.errors.add record.user.name, I18n.t("not_enough_credits")
    end
  end
end
