defmodule Bot.RouterTest do
	use ExUnit.Case
  doctest Example
  @moduledoc """
  	Here gonna be tests for our api. Especially for web hook
	"""

#  describe "Parsing response to JSON" do
#    test "Parsing external response" do
#      data = ~s'{"update_id":571537254,"message":{"message_id":19,"from":{"id":126197867,"first_name":"\u0414\u0430\u0432\u0438\u0434","last_name":"\u0428\u0435\u043a\u0443\u043d\u0446","username":"TZeta"},"chat":{"id":126197867,"first_name":"\u0414\u0430\u0432\u0438\u0434","last_name":"\u0428\u0435\u043a\u0443\u043d\u0446","username":"TZeta","type":"private"},"date":1492877590,"text":"q"}}'
#      res = Davy.BotRouter.decodeWebHookData(data)
#
#      %{"message" => %{"chat" => chat, "text" => text, "from" => from}} = res
#
#      assert chat["id"] == 126197867
#      assert text == "q"
#      assert from["first_name"] == "Давид"
#    end
#  end
end