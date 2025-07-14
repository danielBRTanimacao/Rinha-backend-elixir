import Config

config :rinha_backend, RinhaBackend.Repo,
  username: "postgres",
  password: "password",
  hostname: "localhost",
  database: "payments_db#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :rinha_backend, RinhaBackendWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ljp8KSK2q3bxsN6w41q485iY+nIeQQkW90NYHUfxnF2/M1ij5qWiDRC0KpVxCwH0",
  server: false

config :rinha_backend, RinhaBackend.Mailer, adapter: Swoosh.Adapters.Test

config :swoosh, :api_client, false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime
