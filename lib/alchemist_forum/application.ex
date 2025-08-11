defmodule AlchemistForum.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AlchemistForumWeb.Telemetry,
      AlchemistForum.Repo,
      {DNSCluster, query: Application.get_env(:alchemist_forum, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AlchemistForum.PubSub},
      # Start a worker by calling: AlchemistForum.Worker.start_link(arg)
      # {AlchemistForum.Worker, arg},
      # Start to serve requests, typically the last entry
      AlchemistForumWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AlchemistForum.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AlchemistForumWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
