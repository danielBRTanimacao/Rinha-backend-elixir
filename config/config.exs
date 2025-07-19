import Config

config :rinha_backend,
  ecto_repos: [RinhaBackend.Repo],
  generators: [timestamp_type: :utc_datetime]

config :rinha_backend, RinhaBackendWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: RinhaBackendWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: RinhaBackend.PubSub,
  live_view: [signing_salt: "KZR1GjWq"]

config :rinha_backend, RinhaBackend.Mailer, adapter: Swoosh.Adapters.Local

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
