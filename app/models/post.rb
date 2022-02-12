class Post < ApplicationRecord
  belongs_to :user
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarking_users, through: :bookmarks, source: :user, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags



  attachment :post_image

  validates :title, presence: true
  validates :body, presence: true

  def bookmarked_by?(user)
    bookmarks.where(user_id: user.id).exists?
  end
end
