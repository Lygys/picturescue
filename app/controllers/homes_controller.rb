class HomesController < ApplicationController
  def top
  end

  def search_page
    following = current_user.followings.ids
    @posts = Post.where(user_id: following).order(created_at: :desc).limit(20)
  end
end
