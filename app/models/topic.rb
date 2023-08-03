class Topic < ApplicationRecord
  scope :ordered_topics, -> { order(:name)}
  self.table_name = "tags"
end
