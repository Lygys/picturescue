class Tweet < ApplicationRecord
  belongs_to :user
  has_many :favorites
  has_many :favoriting_users, through: :favorites, source: :user

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.timeline(user)
    followings = user.followings.all.ids
    followings.push(user.id)
    Tweet.where(user_id: followings)
  end

  validates :tweet, presence: true, length: {maximum: 140}
end
