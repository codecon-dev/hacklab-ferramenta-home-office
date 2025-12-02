# lib/tasks/standups_integrations.rake
namespace :standups do
  desc "Enfileira job para buscar integrações e atualizar raw_integrations_data para o dia atual"
  task sync_integrations: :environment do
    Resque.enqueue(FetchStandupIntegrationsJob, Date.current.to_s)
    puts "[standups:sync_integrations] Job enfileirado para #{Date.current}"
  end
end
