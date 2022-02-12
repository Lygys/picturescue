class Tweet < ApplicationRecord
  belongs_to :user
  has_many :favorites
  has_many :favoriting_users, through: :favorites, source: :user

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
