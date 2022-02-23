class CreatorNote < ApplicationRecord
  belongs_to :user
  belongs_to :requester, class_name: 'User'

  validates :user_id, presence: true
  validates :comment, presence: true
end
