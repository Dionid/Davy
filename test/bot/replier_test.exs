defmodule Bot.Replier do
  use ExUnit.Case
	doctest Example
	import ExUnit.CaptureIO
    @moduledoc """
    	Here gonna be tests for our api. Especially for web hook
  	"""

	describe "Parsing response to JSON" do
		test "Parsing external response" do
			start = Davy.BotReplier.parseCmd("/start")
			nothing = Davy.BotReplier.parseCmd("")
			assert start == :start
			assert nothing == :nothing

#			Davy.BotReplier.initCmd("asd", "qwe", start)
#			Davy.BotReplier.initCmd("asd", "qwe", nothing)
		end
	end
end