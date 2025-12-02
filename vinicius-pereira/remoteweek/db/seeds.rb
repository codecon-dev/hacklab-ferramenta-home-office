require "faker"

puts "Checking base data..."

min_orgs = 5
if Organization.count < min_orgs
  puts "Creating #{min_orgs - Organization.count} organizations..."
  (min_orgs - Organization.count).times do
    Organization.create!(
      name: Faker::Company.name,
      slug: Faker::Internet.unique.slug
    )
  end
else
  puts "Organizations OK (#{Organization.count})"
end

orgs = Organization.all

orgs.each do |org|
  min_users = 5
  current = org.users.count
  if current < min_users
    needed = min_users - current
    puts "Adding #{needed} users to #{org.name}"
    needed.times do
      User.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        role: ["member", "manager", "admin"].sample,
        organization: org
      )
    end
  else
    puts "#{org.name}: #{current} users"
  end
end

puts "Generating standups (only missing ones)..."

(30.days.ago.to_date..Date.today).each do |date|
  orgs.each do |org|
    org.users.each do |user|
      next if Standup.exists?(organization: org, user: user, date: date)

      commits = rand(0..10)
      tickets = rand(0..6)

      Standup.create!(
        organization: org,
        user: user,
        date: date,
        yesterday: Faker::Lorem.paragraph(sentence_count: 2),
        today: Faker::Lorem.paragraph(sentence_count: 2),
        blockers: rand < 0.2 ? Faker::Lorem.sentence : nil,
        commits_count: commits,
        support_tickets_resolved: tickets,
        raw_integrations_data: {
          github: {
            repos: Array.new(rand(1..3)) { Faker::App.name },
            total_commits: commits,
            messages: Array.new(commits) { Faker::Hacker.say_something_smart }
          },
          slack: { messages_sent: rand(1..10) },
          support: { tickets: tickets }
        }
      )
    end
  end
end

puts "Creating weekly reports (missing only)..."

8.times do |i|
  week_start = (Date.today - i.weeks).beginning_of_week(:monday)
  week_end   = week_start.end_of_week(:sunday)

  if WeeklyReport.exists?(week_start: week_start)
    puts "Weekly report already exists for week starting #{week_start}, skipping all orgs for this week"
    next
  end

  orgs.each do |org|
    standups = org.standups.where(date: week_start..week_end)
    next if standups.empty?

    members = standups.group_by(&:user).map do |user, s|
      {
        "name" => user.name,
        "commits" => s.sum(&:commits_count),
        "tickets" => s.sum(&:support_tickets_resolved)
      }
    end

    begin
      WeeklyReport.create!(
        organization: org,
        week_start: week_start,
        week_end: week_end,
        generated_at: Time.current,
        report_data: {
          "manager_friendly_text" => "Resumo da semana #{week_start} → #{week_end}.",
          "highlights" => members.sample(2).map { |m| "#{m["name"]} performou acima do normal" },
          "recurring_blockers" => ["Atraso de PR", "Infra lenta", "Dependências externas"].sample(rand(0..2)),
          "members" => members
        }
      )
    rescue ActiveRecord::RecordInvalid => e
      puts "Skipping weekly report for #{org.name}, week #{week_start}: #{e.message}"
    end
  end
end

puts "SEED COMPLETE!"
puts "Orgs: #{Organization.count}, Users: #{User.count}, Standups: #{Standup.count}, Reports: #{WeeklyReport.count}"
