class Public::UsersController < ApplicationController
  def index
    @users = User.all
    @follow_request = current_user.follow_requests.find_by(follow_id: @users.ids)
    @new_follow_request = current_user.follow_requests.new
  end

  def show
    @user = User.find(params[:id])
    @all_posts = @user.posts.all
    @posts = @all_posts.order(created_at: :desc).page(params[:page]).per(20)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
