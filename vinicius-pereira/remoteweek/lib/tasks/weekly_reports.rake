namespace :weekly_reports do
  desc "Enfileira job para gerar relatórios semanais da semana anterior"
  task generate_last_week: :environment do
    Resque.enqueue(GenerateWeeklyReportsJob)
    puts "[weekly_reports:generate_last_week] Job enfileirado para semana anterior"
  end
end
