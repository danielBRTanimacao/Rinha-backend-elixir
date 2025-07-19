import Config

config :rinha_backend, RinhaBackend.Repo,
  username: "postgres",
  password: "password",
  hostname: "localhost",
  database: "payments_db",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :rinha_backend, RinhaBackendWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "OTYzgq7AtNH7gugGSzikbY/L1F0qRIAPWr1YMooU20VTHFd00v6FvUyjAlpmsiDB",
  watchers: []

config :rinha_backend, dev_routes: true

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :swoosh, :api_client, false
