class FollowRequest < ApplicationRecord
  belongs_to :user
  belongs_to :follow, class_name: 'User'

  validates :user_id, presence: true
  validates :follow_id, presence: true
  validates_uniqueness_of :follow_id, scope: :user_id
end
