defmodule Example do
  use Application
  require Logger

  def start(_type, _args) do
  	port = Application.get_env(:example, :cowboy_port)
    children = [
    	Plug.Adapters.Cowboy.child_spec(:http, Davy.BotRouter, [], port: port)
    ]

    Logger.info "Started application on localhost:#{port}"

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
