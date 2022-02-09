class Public::RelationshipsController < ApplicationController


  def create
    @user = User.find(params[:follow_request][:user_id])
    following = accept_follow_request(@user) if follow_requested?(@user)
    if following.save
      @user.remove_follow_request(current_user)
      redirect_to request.referer, notice: "あなたのフォロワーへ追加されました"
    else
      flash.now[:alert] = "フォロワーへ追加できませんでした"
      redirect_to request.referer
    end
  end

  def destroy
    @user = User.find(params[:relationship][:follow_id])
    following = current_user.remove(@user)
    if following.destroy
      redirect_to request.referer, notice: "フォローを解除しました"
    else
      flash.now[:alert] = "フォローを解除できませんでした"
      redirect_to request.referer
    end
  end

  def block
    @user = User.find(params[:relationship][:user_id])
    following = current_user.block(@user)
    if following.destroy
      redirect_to request.referer, notice: "フォロワーから削除されました"
    else
      flash.now[:alert] = "フォロワーから削除されませんでした"
      redirect_to request.referer
    end
  end
end
