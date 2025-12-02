class StandupsController < ApplicationController
  before_action :set_organization

  def index
    @standups =
      if @organization
        @organization.standups.includes(:user).order(date: :desc)
      else
        Standup.includes(:user, :organization).order(date: :desc)
      end
  end

  def show
    @standup = Standup.includes(:user, :organization).find(params[:id])
  end

  def new
    @organization = Organization.find(params[:organization_id])
    @standup = Standup.new
  end

  def create
    @standup = @organization.standups.build(standup_params)

    if @standup.save
      redirect_to standup_path(@standup), notice: "Standup criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_organization
    @organization = Organization.find_by(id: params[:organization_id])
  end

  def standup_params
    params.require(:standup).permit(
      :date, :yesterday, :today, :blockers,
      :commits_count, :support_tickets_resolved,
      :user_id 
    )
  end

end
