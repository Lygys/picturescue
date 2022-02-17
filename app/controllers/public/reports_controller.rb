class Public::ReportsController < ApplicationController
  before_action :authenticate_user!

  def new
    @user = User.find(params[:user_id])
    @report = Report.new
  end

  def create
    @user = User.find(params[:user_id])
    @report = current_user.reports.new(report_params)
    @report.offender_id = @user.id
    if @report.save
      redirect_to user_path(@user), notice: "このユーザーを報告しました"
    else
      @user = User.find(params[:user_id])
      render 'new'
    end
  end

  private
  def report_params
    params.require(:report).permit(:comment, :offender_id, offense_ids: [])
  end

end
