import Config

config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: RinhaBackend.Finch

config :swoosh, local: false

config :logger, level: :info
