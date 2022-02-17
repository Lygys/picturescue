class Report < ApplicationRecord
  has_many :report_offenses, dependent: :destroy
  has_many :offenses, through: :report_offenses
  belongs_to :user
  belongs_to :offender, class_name: 'User'


  validates :comment, presence: true

end
