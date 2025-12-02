Rails.application.routes.draw do
  require "resque/server"

  root "organizations#index"

  resources :organizations, only: [:index, :show] do
    resources :standups
    resources :weekly_reports, only: [:index, :show]
  end
  mount Resque::Server.new => "/resque"

  resources :standups, only: [:show]

  namespace :admin do
    get  "jobs",                         to: "jobs#index",                     as: :jobs
    post "jobs/run_integrations_now",    to: "jobs#run_integrations_now",      as: :run_integrations_now
    post "jobs/generate_missing_reports",to: "jobs#generate_missing_reports",  as: :generate_missing_reports
    post "jobs/generate_last_week_report",to: "jobs#generate_last_week_report",as: :generate_last_week_report
  end

  post "git_events", to: "third_part_events#git_events"
  post "jira_events", to: "third_part_events#jira_events"
end
