class Admin::ReportsController < ApplicationController
  def update
    @user = User.find(params[:user_id])
    @report = Report.find_by(id: params[:id], offender_id: @user.id)
    @report.update(is_finished: true)
    redirect_to request.referer
  end
end
