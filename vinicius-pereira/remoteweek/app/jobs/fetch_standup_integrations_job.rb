class FetchStandupIntegrationsJob
  @queue = :integrations

  def self.perform(date_str = Date.current.to_s)
    date = Date.parse(date_str)
    Standups::FetchIntegrations.call(date)
  end
end
