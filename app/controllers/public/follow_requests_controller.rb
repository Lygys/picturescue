class Public::FollowRequestsController < ApplicationController

  def create
    @user = User.find(params[:follow_id])
    potential_following = current_user.follow_request(@user)
    if potential_following.save
      redirect_to request.referer, notice: "フォロー申請を送りました"
    else
      flash.now[:alert] = "フォロー申請を送れませんでした"
      redirect_to request.referer
    end
  end

  def destroy
    @user = User.find(params[:follow_id])
    potential_following = current_user.remove_follow_request(@user)
    if potential_following.destroy
      redirect_to request.referer, notice: "フォロー申請を解除しました."
    else
      flash.now[:alert] = "フォロー申請を解除できませんでした"
      redirect_to request.referer
    end
  end

  def reject
    @user = User.find(params[:user_id])
    potential_following = current_user.reject_follow_request(@user)
    if potential_following.destroy
      redirect_to request.referer, notice: "フォローリクエストを拒否しました"
    else
      flash.now[:alert] = "フォローリクエストを拒否できませんでした"
      redirect_to request.referer
    end
  end
end
