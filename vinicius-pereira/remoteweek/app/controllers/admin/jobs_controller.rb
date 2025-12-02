# app/controllers/admin/jobs_controller.rb
class Admin::JobsController < ApplicationController
  # before_action :authenticate_admin! # ajuste se tiver auth

  def index
  end

  def run_integrations_now
    Resque.enqueue(FetchStandupIntegrationsJob, Date.current.to_s)
    redirect_to organization_weekly_reports_path(params[:id]), notice: "Job de integrações do dia enfileirado com sucesso."
  end

  def generate_missing_reports
    start = 12.weeks.ago.to_date.beginning_of_week(:monday)

    (start..Date.today).select(&:monday?).each do |week_start|
      week_end = week_start.end_of_week(:sunday)
      next if WeeklyReport.exists?(organization_id: params[:id], week_start: week_start)

      Resque.enqueue(GenerateWeeklyReportsJob, week_start.to_s, week_end.to_s)
    end

    redirect_to organization_weekly_reports_path(params[:id]), notice: "Jobs para gerar relatórios semanais faltantes foram enfileirados."
  end

  def generate_last_week_report
    Resque.enqueue(GenerateWeeklyReportsJob)
    redirect_to organization_weekly_reports_path(params[:id]), notice: "Job para gerar relatório da última semana foi enfileirado."
  end
end
