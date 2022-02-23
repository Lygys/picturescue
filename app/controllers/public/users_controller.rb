class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :potential_followers, :open_request_box, :close_request_box, :open_creator_notes, :close_creator_notes]
  before_action :ensure_guest_user, only: [:edit]

  def index
    @users = User.all.page(params[:page]).per(20)
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
    @users = @user.potential_followers.all.page(params[:page]).per(20)
  end

  def followings
    @user = User.find(params[:id])
    @users = @user.followings.all.page(params[:page]).per(20)
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers.all.page(params[:page]).per(20)
  end

  def bookmarks
    @user = User.find(params[:id])
    @all_bookmarks = @user.bookmark_posts
    @bookmarks = @all_bookmarks.order(created_at: :desc).page(params[:page]).per(20)
  end

  def tweets
    @user = User.find(params[:id])
    @tweet = Tweet.new
    @tweets = @user.tweets.order(created_at: :desc).limit(300).page(params[:page]).per(50)
  end

  def favorite_tweets
    @user = User.find(params[:id])
    @tweets = @user.favorite_tweets.order(created_at: :desc).limit(300).page(params[:page]).per(50)
  end

  def open_request_box
    @user.update(is_open_to_requests: true)
    redirect_to request.referer
  end

  def close_request_box
    @user.update(is_open_to_requests: false)
    redirect_to request.referer
  end

  def open_creator_notes
    @user.update(creator_note_is_private: false)
    redirect_to request.referer
  end

  def close_creator_notes
    @user.update(creator_note_is_private: true)
    redirect_to request.referer
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image, :introduction)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guest-user"
      redirect_to user_path(current_user), notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end
end
