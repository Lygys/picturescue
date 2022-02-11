class Public::TweetsController < ApplicationController

  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user_id = current_user.id
    if @tweet.save
      redirect_to mypage_path(current_user), notice: "投稿が完了しました"
    else

    end
  end

  def index
    @tweet = Tweet.new
    @followings = current_user.followings
    tweets = @followings.inject(init = current_user.tweets){|result, following| result + following.tweets}
    @tweets = tweets.order(created_at: :desc).page(params[:page]).per(50)
  end

  def show
    @tweet = Tweet.find(params[:id])
  end






  private
  def tweet_params
    params.require(:tweet).permit(:tweet)
  end
end
