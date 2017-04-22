defmodule Davy.BotPoller do
  @moduledoc false
  
  use GenServer
	require Logger

  def start_link(state, opts) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def init(state) do
		Logger.info "Puller started"
		spawn fn ->
			handle_cast(:start_pool, state)
	 	end
		{:ok, state}
  end

  def handle_cast(:start_pool, state) do
  	do_pool(state)
    {:noreply, state}
  end

  def do_pool(args) do
    %{"update_id" => update_id} = Davy.Bot.getUserMsgs(args)
    do_pool(%{timeout: args[:timeout], update_id: update_id + 1})
  end
end