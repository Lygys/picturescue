class HomesController < ApplicationController

  before_action :authenticate_user!, only: [:search_page]

  def top
  end

  def search_page
    @posts = Post.followings_new_posts(current_user).order(created_at: :desc).limit(20)
  end

  def block_page
  end
end
