require "resque"

Resque.redis = ENV.fetch("REDIS_URL") { "redis://localhost:6379/0" }

# Opcional: carrega automaticamente workers em app/jobs ou app/workers
Dir[Rails.root.join("app/jobs/*.rb")].each { |file| require file }
  