defmodule Davy.BotReplier do
  @moduledoc false

  def reply(chatId, from, text) do
		text
		|> parseCmd
		|> initCmd(chatId, from)
  end

  def parseCmd(text) do
    case text do
    	"/start" -> :start
    	"Я хочу есть" -> :eda
      "" -> :nothing
      _ -> :nothing
    end
  end

  def initCmd(:nothing, chatId, from) do
  	Davy.BotTelApi.sendMessage(chatId, "I don't know this :(")
	end

	def initCmd(:eda, chatId, from) do
    	Davy.BotTelApi.sendMessage(chatId, "Так сам себе и приготовь, чуркобес...")
  	end

  def initCmd(:start, chatId, from) do
		Davy.BotTelApi.sendMessage(chatId, "Let's start!")
  end
end