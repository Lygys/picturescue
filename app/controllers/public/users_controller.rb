class Public::UsersController < ApplicationController


  def show
    @user = User.find(params[:id])
    @all_posts = @user.posts.all
    @posts = @all_posts.order(created_at: :desc).page(params[:page]).per(24)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
