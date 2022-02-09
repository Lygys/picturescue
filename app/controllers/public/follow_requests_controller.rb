class Public::FollowRequestsController < ApplicationController
  before_action :set_user

  def set_user
    @user = User.find(params[:follow_request][:follow_id])
  end

  def create
    potential_following = current_user.follow_request(@user)
    if potential_following.save
      redirect_to request.referer, notice: "フォロー申請を送りました"
    else
      flash.now[:alert] = "フォロー申請を送れませんでした"
      redirect_to request.referer
    end
  end

  def destroy
    potential_following = current_user.remove_follow_request(@user)
    if potential_following.destroy
      redirect_to request.referer, notice: "フォロー申請を解除しました."
    else
      flash.now[:alert] = "フォロー申請を解除できませんでした"
      redirect_to request.referer
    end
  end
end
