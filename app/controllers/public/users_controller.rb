class Public::UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :potential_followers]

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @all_posts = @user.posts.all
    @posts = @all_posts.order(created_at: :desc).page(params[:page]).per(20)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "ユーザー情報の編集が完了しました"
    else
      render "edit"
    end
  end

  def potential_followers
    @user = User.find(params[:id])
    @users = @user.potential_followers.all
  end

  def followings
    @user = User.find(params[:id])
    @users = @user.followings.all
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers.all
  end


  def bookmarks
    @user = User.find(params[:id])
    @all_bookmarks = @user.bookmark_posts
    @bookmarks = @all_bookmarks.order(created_at: :desc).page(params[:page]).per(20)
  end

  def tweets
    @user = User.find(params[:id])
    @tweet = Tweet.new
    @tweets = @user.tweets.order(created_at: :desc).page(params[:page]).per(50)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image, :introduction)
  end
end
