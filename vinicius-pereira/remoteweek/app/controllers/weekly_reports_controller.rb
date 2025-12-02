class WeeklyReportsController < ApplicationController
  before_action :set_organization

  def index
    @standups = @organization.standups
    @weekly_reports = @organization.weekly_reports.order(week_start: :desc)
    @reports_data = @organization.weekly_reports.last.report_data
  end

  def show
    @weekly_report = @organization.weekly_reports.find(params[:id])
  end

  private

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end
end
