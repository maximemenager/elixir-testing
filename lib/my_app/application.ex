defmodule MyApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = children(Mix.env())

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def children(:test), do: []

  def children(_) do
    [
      {Plug.Cowboy,
       scheme: :http,
       plug: MyApp.StipeServer,
       options: [port: System.get_env("PORT", "4000") |> String.to_integer()]}
    ]
  end
end
