defmodule Bot.Replier do
  use ExUnit.Case, async: false
	#	doctest Davy.BotReplier
	import Davy.BotReplier

	@usersTableName Application.get_env(:example, :usersTableName)
	setup_all do
		table = :ets.new(@usersTableName, [:set, :public, :named_table])
		:ets.insert(table, {4321, :product_name, %{product_name: "Iphone 7s"}})
		{:ok, table: table}
	end

	@moduledoc """
		Here gonna be tests for our api. Especially for web hook
	"""

	describe "ets" do
	  test "find user", (state) do
			assert :ets.lookup(state[:table], 4321) === [{4321, :product_name, %{product_name: "Iphone 7s"}}]
	  end
	end

	describe "Davy bot replier" do
	  test "must get user by his telegramm id" do
	    assert getOrCreateUser(%{id: 4321}) === %{id: 4321, current_status: :product_name, answers: %{product_name: "Iphone 7s"}}
	  end
	  test "must create new user by telegramm id" do
	    assert getOrCreateUser(%{id: 1234}) === %{id: 1234, current_status: :product_name, answers: %{}}
	  end

	  test "get command from text" do
	    assert getCmd("") === :unknown
			assert getCmd("/start") === :start
			assert getCmd("Iphone 7s") === :product
	  end

	  test "get command by user and text" do
	    assert(
	    	getCmdByUser(%{id: 123456, status: :product_name}, "asd")
	    		===
				{:product, %{id: 123456, status: :product_name}}
			)
	  end

	  test "get next status in a qeue" do
	    assert getNextStatus(:nothing) === :product_name
	  end

		test "save answer and newStatus, retriewing it" do
		  assert(
				saveAnswerAndSetNewStatus(:product_name, %{id: 123, current_status: :product_name, answers: %{}}, "Iphone 7s")
				===
				:product_name
      )
		end

		test "setting new status" do
		  assert setNewStatus(getOrCreateUser(%{id: 1234}), :product_price) === :ok
		  %{current_status: current_status} = getOrCreateUser(%{id: 1234})
		  assert current_status === :product_price
		end

	end

end