class Admin::OffensesController < ApplicationController
  before_action :authenticate_admin!

  def create
    @offense = Offense.new(offense_params)
    @offense.save
    redirect_to request.referer
  end

  def index
    @offenses = Offense.all
    @offense = Offense.new
  end

  def edit
    @offense = Offense.find(params[:id])
  end

  def update
    @offense = Offense.find(params[:id])
    @offense.update(offense_params)
    redirect_to admin_offenses_path
  end

  def destroy
    @offense = Offense.find(params[:id])
    @offense.destroy
    redirect_to request.referer
  end

  private

  def offense_params
    params.require(:offense).permit(:name)
  end
end
