module Standups
  class FetchIntegrations
    def self.call(date = Date.current)
      new(date).call
    end

    def initialize(date)
      @date = date
    end

    def call
      Organization.includes(:users).find_each do |organization|
        organization.users.each do |user|
          standup = Standup.find_by(date: @date, organization: organization, user: user)
          next unless standup 

          simulated_data = build_simulated_data(organization, user, standup)

          standup.update!(
            raw_integrations_data: simulated_data,
            commits_count: simulated_data.dig(:github, :total_commits),
            support_tickets_resolved: simulated_data.dig(:support, :tickets_resolved)
          )
        end
      end
    end

    private

    def build_simulated_data(organization, user, standup)
      commits = Array.new(rand(1..5)) do |i|
        {
          sha: SecureRandom.hex(8),
          message: "Refactoring on #{organization.slug} – part #{i + 1}",
          repo: "#{organization.slug}-api",
          timestamp: (@date.to_time + rand(9..18).hours).iso8601
        }
      end

      tickets = Array.new(rand(0..3)) do |i|
        {
          id: "SUP-#{rand(1000..9999)}",
          title: "Cliente reportou bug #{i + 1}",
          status: "resolved",
          resolved_at: (@date.to_time + rand(10..19).hours).iso8601
        }
      end

      slack_messages = Array.new(rand(1..4)) do
        {
          channel: "#daily-#{organization.slug}",
          text: "Update rápido do #{user.name} no standup.",
          timestamp: (@date.to_time + rand(9..11).hours).iso8601
        }
      end

      {
        date: @date,
        organization: {
          id: organization.id,
          name: organization.name,
          slug: organization.slug
        },
        user: {
          id: user.id,
          name: user.name,
          email: user.email
        },
        github: {
          total_commits: commits.size,
          commits: commits
        },
        support: {
          tickets_resolved: tickets.size,
          tickets: tickets
        },
        slack: {
          messages_count: slack_messages.size,
          messages: slack_messages
        },
        standup_summary: {
          yesterday: standup.yesterday,
          today: standup.today,
          blockers: standup.blockers
        }
      }
    end
  end
end
