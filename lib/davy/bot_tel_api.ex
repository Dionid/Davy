defmodule Davy.BotTelApi do
  @moduledoc false

  @api_url "https://api.telegram.org/bot"

  defp getToken do
    Application.get_env(:example, :botToken)
  end


  defp build_url(method) do
		@api_url <> getToken() <> "/" <>method
	end

	defp makeRequest(method, request \\ [], timeout \\ 5) do
		resUrl = build_url(method)
	  case HTTPoison.post(resUrl, request) do
			{:ok, %HTTPoison.Response{status_code: _, body: body}} -> Poison.decode(body)
			{:error, %HTTPoison.Error{id: nil, reason: reason}} -> IO.inspect reason
		end
	end

	def sendMessage(chat_id, text, parse_mode \\ nil, disable_web_page_preview \\ false,
									 reply_to_mensaje_id \\ nil, reply_markup \\ %{"reply_markup" => []}) do
		body = {
			:form,
			[
				chat_id: chat_id,
#				parse_mode: parse_mode,
				text: text,
				disable_web_page_preview: disable_web_page_preview,
				reply_to_mensaje_id: reply_to_mensaje_id,
				reply_markup: reply_markup |> Poison.encode!
			]
		}
	  makeRequest("sendMessage", body)
	end

end