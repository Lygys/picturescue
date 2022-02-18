class Post < ApplicationRecord
  belongs_to :user
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarking_users, through: :bookmarks, source: :user, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags


  def save_tags(savepost_tags)
    # 現在のユーザーの持っているskillを引っ張ってきている
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 今postが持っているタグと今回保存されたものの差をすでにあるタグとする。古いタグは消す。
    old_tags = current_tags - savepost_tags
    # 今回保存されたものと現在の差を新しいタグとする。新しいタグは保存
    new_tags = savepost_tags - current_tags

    # Destroy old taggings:
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name: old_name)
    end

    # Create new taggings:
    new_tags.each do |new_name|
      post_tag = Tag.find_or_create_by(name: new_name)
      # 配列に保存
      self.tags << post_tag
    end
  end

  def self.search_for(content, method)
    if method == 'perfect'
      Post.where(title: content)
    else
      Post.where('title LIKE ?', '%'+content+'%')
    end
  end

  attachment :post_image

  validates :title, presence: true
  validates :body, presence: true

  def bookmarked_by?(user)
    bookmarks.where(user_id: user.id).exists?
  end

end
