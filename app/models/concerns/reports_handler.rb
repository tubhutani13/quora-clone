module ReportsHandler
  def self.included(klass)
    klass.class_eval do
      has_many :reports, as: :reportable
      validates :published_at, reportable_threshold: true, if: :published?
      scope :published, -> { where.not(published_at: :nil) }
    end
  end

  def unpublish
    update(published_at: nil)
  end

  def published?
    published_at.present?
  end

  def unpublished?
    reports.count >= REPORTS_THRESHOLD || !published?
  end
end
