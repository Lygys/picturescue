class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :posts, through: :post_tags

  validates :name, presence: true

  def self.search_posts_for(content, method)
    if method == 'perfect'
      tags = Tag.where(name: content)
    else
      tags = Tag.where('name LIKE ?', '%' + content + '%')
    end
    post_ids = tags.inject(init = []) {|result, tag| result + tag.posts.ids}
    Post.where(id: post_ids)
  end

end
