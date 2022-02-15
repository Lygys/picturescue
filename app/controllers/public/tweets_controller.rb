class Public::TweetsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:destroy]

  def ensure_correct_user
    @tweet = Tweet.find(params[:id])
    unless @tweet.user == current_user
      redirect_to user_path(current_user)
    end
  end

  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user_id = current_user.id
    if @tweet.save
      redirect_to request.referer, notice: "ツイートしました"
    else
      redirect_to request.referer, notice: "ツイートできませんでした"
    end
  end

  #current_userのタイムライン
  def index
    @tweet = Tweet.new
    followings = current_user.followings.all.ids
    followings.push(current_user.id)
    tweets = Tweet.where(user_id: followings)
    @tweets = tweets.order(created_at: :desc).limit(300).page(params[:page]).per(50)
  end

  def show
    @tweet = Tweet.find(params[:id])
  end

  def destroy
    if @tweet.destroy
      redirect_to tweets_user_path(current_user), notice: "ツイートを削除しました"
    else
      redirect_to request.referer, notice: "ツイートを削除できませんでした"
    end
  end

  def favoriting_users
    @tweet = Tweet.find(params[:id])
    @users = @tweet.favoriting_users.page(params[:page]).per(20)
  end

  private
  def tweet_params
    params.require(:tweet).permit(:tweet)
  end
end
