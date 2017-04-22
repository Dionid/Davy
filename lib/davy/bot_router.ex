defmodule Davy.BotRouter do
  use Plug.Router
  require Logger

  plug :match
  plug :dispatch

  get "/", do: send_resp(conn, 200, "Welcome")
	post "/webhook" do
		{:ok, data, _none} = Plug.Conn.read_body(conn)
	  jsonData = decodeWebHookData(data)

	  %{"message" => %{"chat" => chat, "text" => text, "from" => from}} = jsonData

		#	  Logger.info chat["id"]
		#	  Logger.info from["first_name"]
	  Logger.info text

	  Davy.BotReplier.reply(chat["id"], from["first_name"], text)

	  send_resp(conn, 200, "Welcome")
	end

	def decodeWebHookData(data) do
	  {:ok, jData} =  Poison.decode(data)
		#		Logger.info inspect jData
		jData
	end
end

#"message":
#{"message_id":5,"from":{"id":126197867,"first_name":"\u0414\u0430\u0432\u0438\u0434","last_name":"\u0428\u0435\u043a\u0443\u043d\u0446","username":"TZeta"},"chat":{"id":126197867,"first_name":"\u0414\u0430\u0432\u0438\u0434","last_name":"\u0428\u0435\u043a\u0443\u043d\u0446","username":"TZeta","type":"private"},"date":1492870285,"text":"asd"}}