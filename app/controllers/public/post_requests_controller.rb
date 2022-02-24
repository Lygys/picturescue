class Public::PostRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:update, :reset]
  before_action :ensure_host_status, only: [:new, :create]

  def new
    @post_request = PostRequest.new
    @user = User.find(params[:user_id])
  end

  def create
    @user = User.find(params[:user_id])
    @post_request = current_user.post_requests.new(post_request_params)
    @post_request.host_id = @user.id
    if @post_request.save
      redirect_to user_post_requests_path(@user), notice: "リクエストを送りました"
    else
      @user = User.find(params[:user_id])
      render 'new'
    end
  end

  def index
    @user = User.find(params[:user_id])
    @request_box = @user.received_requests.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @user = User.find(params[:user_id])
    @post_request = PostRequest.find_by(id: params[:id], host_id: @user.id)
    @note = CreatorNote.new
  end

  # リクエストを受けた側のアクション
  def update
    @user = User.find(params[:user_id])
    @post_request = PostRequest.find_by(id: params[:id], host_id: @user.id)
    if @post_request.update(post_request_params)
      redirect_to user_post_request_path(@user, @post_request)
    else
      flash.now[:alert] = "返信メッセージを送れませんでした"
      redirect_to request.referer
    end
  end

  # リクエストを送った側のアクション
  def destroy
    @user = User.find(params[:user_id])
    @post_request = PostRequest.find_by(id: params[:id], host_id: @user.id)
    if @post_request.user != current_user
      redirect_to user_path(current_user)
    elsif @post_request.destroy
      redirect_to user_post_requests_path(@user), notice: "リクエストを削除しました"
    else
      flash.now[:alert] = "リクエストを削除できませんでした"
      redirect_to request.referer
    end
  end

  # リクエストを受けた側のアクション
  def reset
    @user = User.find(params[:user_id])
    @post_requests = PostRequest.where(host_id: @user.id)
    if @post_requests.destroy_all
      redirect_to user_post_requests_path(@user), notice: "お題箱をリセットしました"
    else
      flash.now[:alert] = "お題箱をリセットできませんでした"
      redirect_to request.referer
    end
  end

  private

  def post_request_params
    params.require(:post_request).permit(:comment, :host_comment, :is_annonymous)
  end

  def ensure_correct_user
    @user = User.find(params[:user_id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def ensure_host_status
    @user = User.find(params[:user_id])
    if @user.is_open_to_requests == false
      redirect_to user_path(current_user)
    end
  end
end
