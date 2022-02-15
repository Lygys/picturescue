class Public::PostRequestsController < ApplicationController
  #他ユーザーがホストにリクエストを送るためのフォームを作る
  def new
    @post_request = PostRequest.new
  end

　#他ユーザーがホストにリクエストを送る
　def create
　  @post_request = PostRequest.new(post_request_params)
　  @post_request.user_id = current_user.id
　end
　#
  def index
    @user = User.find(params[:id])
    @post_requests = PostRequest.where(host_id: @user.id).order(created_at: :desc)
  end
  #他ユーザーがホストに送ったリクエストを消す
  def destroy

  end

end
