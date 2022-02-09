class Public::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @all_posts = @user.posts.all
    @posts = @all_posts.order(created_at: :desc).page(params[:page]).per(20)
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

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
