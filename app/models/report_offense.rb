class ReportOffense < ApplicationRecord
  belongs_to :report
  belongs_to :offense
end
