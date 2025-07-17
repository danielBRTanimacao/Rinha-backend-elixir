defmodule RinhaBackend.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RinhaBackendWeb.Telemetry,
      RinhaBackend.Repo,
      {DNSCluster, query: Application.get_env(:rinha_backend, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: RinhaBackend.PubSub},
      RinhaBackend.Payments.HealthService,
      {Finch, name: RinhaBackend.Finch},
      RinhaBackendWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: RinhaBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    RinhaBackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
