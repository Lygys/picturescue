class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.extract_offenders.page(params[:page]).per(20)
  end

  def show
    @user = User.find(params[:id])
    @reports = @user.recieved_reports.page(params[:page]).per(20)
  end

  def destroy_all_tweets
    @user = User.find(params[:id])
    @tweets = Tweet.where(user_id: @user.id)
    if @tweets.destroy_all
      redirect_to request.referer, notice: "ツイートを全削除しました"
    else
      flash.now[:alert] = "ツイートを削除できませんでした"
      redirect_to request.referer
    end
  end

  def destroy_all_comments
    @user = User.find(params[:id])
    @comments = Comment.where(user_id: @user.id)
    if @comments.destroy_all
      redirect_to request.referer, notice: "コメントを全削除しました"
    else
      flash.now[:alert] = "コメントを削除できませんでした"
      redirect_to request.referer
    end
  end

  def destroy_all_posts
    @user = User.find(params[:id])
    @posts = Post.where(user_id: @user.id)
    if @posts.destroy_all
      redirect_to request.referer, notice: "投稿を全削除しました"
    else
      flash.now[:alert] = "投稿を削除できませんでした"
      redirect_to request.referer
    end
  end

  def clear_all_reports
    @user = User.find(params[:id])
    @reports = Report.where(offender_id: @user.id, is_finished: true)
    if @reports.destroy_all
      redirect_to request.referer, notice: "処理済の報告を削除しました"
    else
      flash.now[:alert] = "処理済の報告を削除できませんでした"
      redirect_to request.referer
    end
  end

  def block
    @user = User.find(params[:id])
    @reports = Report.where(offender_id: @user.id)
    @tweets = Tweet.where(user_id: @user.id)
    @comments = Comment.where(user_id: @user.id)
    @posts = Post.where(user_id: @user.id)
    if @user.update(is_blocked: true)
      @reports.destroy_all
      @tweets.destroy_all
      @comments.destroy_all
      @posts.destroy_all
      redirect_to request.referer, notice: "ユーザーをブロックしました"
    else
      flash.now[:alert] = "ユーザーをブロックできませんでした"
      redirect_to request.referer
    end
  end

  def remove_block
    @user = User.find(params[:id])
    if @user.update(is_blocked: false)
      redirect_to request.referer, notice: "ブロックを解除しました"
    else
      flash.now[:alert] = "ブロックを解除できませんでした"
      redirect_to request.referer
    end
  end

end
