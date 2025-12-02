namespace :reports do
  desc "Gerar relatórios semanais faltantes manualmente (opcional ORGANIZATION_ID=1)"
  task generate_missing: :environment do
    org_scope = if ENV["ORGANIZATION_ID"]
                  Organization.where(id: ENV["ORGANIZATION_ID"])
                else
                  Organization.all
                end

    start = 12.weeks.ago.to_date.beginning_of_week(:monday)

    (start..Date.today).select { |d| d.monday? }.each do |week_start|
      week_end = week_start.end_of_week(:sunday)

      org_scope.each do |org|
        next if WeeklyReport.exists?(organization: org, week_start: week_start)

        standups = org.standups.where(date: week_start..week_end)
        next if standups.empty?

        puts "Gerando relatório para #{org.name} | #{week_start} → #{week_end}"
        Resque.enqueue(GenerateWeeklyReportsJob, week_start.to_s, week_end.to_s)
      end
    end

    puts "Concluído"
  end
end
