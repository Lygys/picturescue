class User < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :post, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_tweets, through: :favorites, source: :tweet, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :tweets, dependent: :destroy

  has_many :post_requests, dependent: :destroy
  has_many :received_requests, class_name: 'PostRequest', foreign_key: 'host_id', dependent: :destroy

  has_many :creator_notes, dependent: :destroy
  has_many :request_notes, class_name: 'PostRequest', foreign_key: 'requester_id', dependent: :destroy

  has_many :reports, dependent: :destroy
  has_many :recieved_reports, class_name: 'Report', foreign_key: 'offender_id', dependent: :destroy

  has_many :follow_requests
  has_many :potential_followings, through: :follow_requests, source: :follow, dependent: :destroy
  has_many :reverse_of_follow_requests, class_name: 'FollowRequest', foreign_key: 'follow_id'
  has_many :potential_followers, through: :reverse_of_follow_requests, source: :user, dependent: :destroy

  has_many :relationships
  has_many :followings, through: :relationships, source: :follow, dependent: :destroy
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user, dependent: :destroy


  attachment :profile_image
  validates :name, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable



  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end



  def follow_requesting?(other_user)
    self.potential_followings.include?(other_user)
  end

  def follow_requested_by?(other_user)
    self.potential_followers.include?(other_user)
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  def followed_by?(other_user)
    self.followers.include?(other_user)
  end

  def follow_request(other_user)
    unless self == other_user
      self.follow_requests.find_or_create_by(follow_id: other_user.id)
    end
  end

  def remove_follow_request(other_user)
    follow_request = self.follow_requests.find_by(follow_id: other_user.id)
    follow_request.destroy if follow_request
  end

  def accept_follow_request(other_user)
    unless self == other_user
      Relationship.find_or_create_by(user_id: other_user.id, follow_id: self.id)
    end
  end

  def reject_follow_request(other_user)
    follow_request = FollowRequest.find_or_create_by(user_id: other_user.id, follow_id: self.id)
    follow_request.destroy if follow_request
  end

  def block(other_user)
    relationship = Relationship.find_by(user_id: other_user.id, follow_id: self.id)
    relationship.destroy if relationship
  end

  def remove(other_user)
    relationship = Relationship.find_by(user_id: self.id, follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def self.extract_offenders
    reports = Report.all
    offender_ids = []
    reports.each do |report|
      offender_ids.push(report.offender_id)
    end
    return User.where(id: offender_ids)
  end
end
