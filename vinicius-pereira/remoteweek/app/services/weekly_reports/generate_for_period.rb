module WeeklyReports
  class GenerateForPeriod
    def self.call(week_start:, week_end:)
      Organization.find_each do |organization|
        new(organization, week_start, week_end).call
      end
    end

    def initialize(organization, week_start, week_end)
      @organization = organization
      @week_start = week_start
      @week_end   = week_end
    end

    def call
      standups = @organization.standups
                              .includes(:user)
                              .where(date: @week_start..@week_end)

      return if standups.empty?

      report = WeeklyReport.find_or_initialize_by(
        organization: @organization,
        week_start:   @week_start,
        week_end:     @week_end
      )

      report.generated_at = Time.current
      report.report_data  = build_report_data(standups)
      report.save!
    end


























































           






    private

    def build_report_data(standups)
      members_data = standups.group_by(&:user).map do |user, user_standups|
        {
          "name"    => user.name,
          "commits" => user_standups.sum(&:commits_count),
          "tickets" => user_standups.sum(&:support_tickets_resolved)
        }
      end

      blockers_texts = standups.map(&:blockers).compact.reject(&:blank?)

      recurring_blockers = blockers_texts
        .flat_map { |b| b.split("\n") }
        .map(&:strip)
        .reject(&:blank?)
        .group_by(&:itself)
        .select { |_, occurrences| occurrences.size > 1 }
        .keys

      highlights = []
      top_member = members_data.max_by { |m| m["commits"] + m["tickets"] }

      if top_member
        highlights << "#{top_member["name"]} teve maior impacto na semana "\
                      "(#{top_member["commits"]} commits e "\
                      "#{top_member["tickets"]} tickets resolvidos)."
      end

      org_name = @organization.name

      manager_text = <<~TEXT
        Semana de #{@week_start.strftime("%d/%m")} a #{@week_end.strftime("%d/%m")} em #{org_name}.

        • Total de standups: #{standups.count}
        • Total de commits: #{standups.sum(&:commits_count)}
        • Tickets de suporte resolvidos: #{standups.sum(&:support_tickets_resolved)}

        Abaixo você encontra destaques por membro e bloqueios recorrentes que podem precisar de atenção.
      TEXT

      {
        "manager_friendly_text" => manager_text.strip,
        "highlights"            => highlights,
        "recurring_blockers"    => recurring_blockers,
        "members"               => members_data
      }
    end
  end
end
