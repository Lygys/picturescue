class Offense < ApplicationRecord
  has_many :report_offenses, dependent: :destroy, foreign_key: 'offense_id'
  has_many :reports, through: :report_offenses

  validates :name, presence: true
end
