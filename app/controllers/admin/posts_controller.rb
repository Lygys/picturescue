class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @user = User.find(params[:user_id])
    @posts = Post.where(user_id: @user.id).page(params[:page]).per(20)
  end

  def show
    @user = User.find(params[:user_id])
    @post = Post.find_by(id: params[:id], user_id: @user.id)
  end

  def destroy
    @user = User.find(params[:user_id])
    @post = Post.find_by(id: params[:id], user_id: @user.id)
    if @post.destroy
      redirect_to request.referer, notice: "投稿を削除しました"
    else
      flash.now[:alert] = "投稿を削除できませんでした"
      redirect_to request.referer
    end
  end
end
