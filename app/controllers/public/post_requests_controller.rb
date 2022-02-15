class Public::PostRequestsController < ApplicationController
  def new
    @post_request = PostRequest.new
    @user = User.find(params[:user_id])
  end

  def create
    @user = User.find(params[:user_id])
    @post_request = current_user.post_requests.new(post_request_params)
    @post_request.host_id = @user.id
    if @post_request.save
      redirect_to request_box_user_path(@user)
    else
      @user = User.find(params[:user_id])
      render 'new'
    end
  end

  def show
    @user = User.find(params[:user_id])
    @post_request = PostRequest.find_by(id: params[:id], host_id: @user.id)
  end

  ###リクエストを受けた人のためのアクション
  def update
    @user = User.find(params[:user_id])
    @post_request = PostRequest.find_by(id: params[:id], host_id: @user.id)
    if @post_request.update(post_request_params)
      flash.now[:alert] = "返信メッセージを送りました"
      redirect_to user_post_request_path(@user, @post_request)
    else
      flash.now[:alert] = "返信メッセージを送れませんでした"
      request.referer
    end
  end


  def destroy
    @user = User.find(params[:user_id])
    @post_request = PostRequest.find_by(id: params[:id], host_id: @user.id)
    if @post_request.destroy
      redirect_to request_box_user_path(@user)
    else
      flash.now[:alert] = "リクエストを削除できませんでした"
      request.referer
    end
  end





  private

  def post_request_params
    params.require(:post_request).permit(:comment, :host_comment, :is_annonymous)
  end

end