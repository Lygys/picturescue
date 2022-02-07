class Post < ApplicationRecord
  belongs_to :user
  has_many :bookmarks
  has_many :bookmarked_users, through: :bookmarks, source: :user
  has_many :comments
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags



  attachment :post_image

  def bookmarked_by?(user)
    bookmarks.where(user_id: user.id).exists?
  end
end
