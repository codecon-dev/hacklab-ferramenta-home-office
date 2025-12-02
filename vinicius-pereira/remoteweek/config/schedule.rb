set :output, "log/cron.log"
set :environment, ENV.fetch("RAILS_ENV", "production")

every 1.day, at: '23:59' do
  rake "standups:sync_integrations"
end

every :monday, at: '00:30' do
  rake "weekly_reports:generate_last_week"
end

every 1.day, at: '00:30' do
  rake "reports:generate_missing"
end

