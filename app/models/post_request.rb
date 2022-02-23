class PostRequest < ApplicationRecord
  belongs_to :user
  belongs_to :host, class_name: 'User'

  validates :user_id, presence: true
  validates :host_id, presence: true
  validates :comment, presence: true
end
