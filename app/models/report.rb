class Report < ApplicationRecord
  after_create_commit :unpublish_reportable
  
  belongs_to :user
  belongs_to :reportable, polymorphic: true

  validates_presence_of :reason
  validates :user_id, uniqueness: { scope: [:reportable_id, :reportable_type], message: "Already Reported" }

  def unpublish_reportable
    if reportable.reports.count >= REPORTS_THRESHOLD
      reportable.unpublish
    end
  end
end
