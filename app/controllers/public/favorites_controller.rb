class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!
  def create
    @tweet = Tweet.find(params[:tweet_id])
    favorite = @tweet.favorites.new(user_id: current_user.id)
    favorite.save
  end

  def destroy
    @tweet = Tweet.find(params[:tweet_id])
    favorite = @tweet.favorites.find_by(user_id: current_user.id)
    favorite.destroy
  end
end
