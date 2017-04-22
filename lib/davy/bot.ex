defmodule Davy.Bot do
  @moduledoc false

  def getUserMsgs(%{timeout: timeout, update_id: offset}) do
    exec_cmd("getMsgs", %{timeout: timeout, update_id: offset}) |> process_replies
  end

  def exec_cmd(cmd, params) do
		# api(cmd, {}, params: params)
  end

  def unfoled_resp({:ok, %{"ok" => true, "result" => result}}) do
    result
  end

  def process_replies([msg]) do
    process_reply msg
    msg
  end

  def process_replies([msg|tail]) do
      process_reply msg
      process_replies tail
	end

	def process_reply(msg) do
		spawn fn ->
			Davy.BotReplier.reply(msg)
	 	end
	end

end