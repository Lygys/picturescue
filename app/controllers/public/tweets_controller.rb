class Public::TweetsController < ApplicationController

  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user_id = current_user.id
    if @tweet.save
      redirect_to request.referer, notice: "ツイートしました"
    else
      redirect_to request.referer, notice: "ツイートできませんでした"
    end
  end

  def index
    @tweet = Tweet.new
    followings = current_user.followings.all.ids
    followings.push(current_user)
    tweets = Tweet.where(user_id: followings)
    @tweets = tweets.order(created_at: :desc).limit(300).page(params[:page]).per(50)
  end

  def show
    @tweet = Tweet.find(params[:id])
  end






  private
  def tweet_params
    params.require(:tweet).permit(:tweet)
  end
end
