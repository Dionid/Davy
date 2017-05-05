defmodule Davy.BotReplier do

	@usersTableName Application.get_env(:example, :usersTableName)

  @doc ~S"""
  	Process user message: get/create the user, save answer and send the next question
	"""

  def processUserMessage(chatId, from, text) do
    getOrCreateUser(from)
    	|> getCmdByUser(text)
    	|> initCmd(text, chatId, from)
  end

  @doc """
	  Get user from Redis \ ETS or create if no one found
	"""

  def getOrCreateUser(from) do
  	case :ets.lookup(@usersTableName, from.id) do
  	  [] ->
  	  	:ets.insert(@usersTableName, {from.id, :product_name, %{}})
  	  	%{id: from.id, current_status: :product_name, answers: %{}}
  	  [{id, current_status, answers}] -> %{id: id, current_status: current_status, answers: answers}
  	end
  end

	@doc ~S"""
		# ? Возможно ли обозначить, что нас не интересует количество оставшихся аргументов?
	"""

  def getCmdByUser(user, text) do
    # В зависимости от статуса выбрать команду: показать список, распознать ответ человека
    cmd = getCmd(text)
    { cmd, user }
  end

  @doc ~S"""
		Parse user text to get comand
	"""

	def getCmd(text) do
		case text do
			"/start" -> :start
			"/list" -> :list
			"/reset" -> :reset
			"" -> :unknown
			_ -> :product
		end
	end

	@statuses [:nothing, :product_name, :product_price, :productTimer, :complete]

  def initCmd({:product, internalUser}, text, chatId, from) do
		if internalUser.current_status === :complete do
			case checkIfAgreed(text) do
				:ok -> setNewStatus(internalUser, :nothing) |> sendCongrads(chatId)
				:error ->
					setNewStatus(internalUser, :product_name)
					initCmd({:product, internalUser}, text, chatId, from)
			end
		else
		  getNextStatus(internalUser.currentStatus)
				|> saveAnswerAndSetNewStatus(internalUser, text)
				|> getNewQuestionByNewStatus
				|> sendQuestion(chatId, from)
		end
  end

  @doc ~S"""
		Getting next status
	"""

  def getNextStatus(current_status) do
    newStatusIndex = Enum.find_index(@statuses, fn(x) -> x === current_status end) + 1
    Enum.at @statuses, newStatusIndex
  end

  def sendCongrads(:ok, chatId) do
    Davy.BotTelApi.sendMessage(chatId, "Успешно завершено! Чтобы начать занаво, просто пришлите название интересующего товара! Удачи!")
  end

  def checkIfAgreed(text) do
    :ok
  end

  def setNewStatus(internalUser, newStatus) do
    :ets.insert(@usersTableName, {internalUser.id, newStatus, internalUser.answers})
    :ok
  end

  @doc ~S"""
		Save answer and newStatus, retriewing it
	"""

  def saveAnswerAndSetNewStatus(newStatus, internalUser, text) do
		current_status = internalUser.current_status
		:ets.insert(@usersTableName, {internalUser.id, newStatus, Map.merge(internalUser.answers, %{current_status => text})})
		newStatus
  end

	@doc ~S"""
		Save answer and newStatus, retriewing it

		iex> Davy.BotReplier.getNewQuestionByNewStatus(:product_price)
		"Price of product"
	"""

  def getNewQuestionByNewStatus(current_status) do
		case current_status do
		  :product_name -> "Name of product"
		  :product_price -> "Price of product"
		  :complete -> "All done. Lets start?"
		end
  end

  def sendQuestion(internalUser, chatId, from) do

  end

  @doc ~S"""
    	Common commands

#    	iex> Davy.BotReplier.initCmd({:start, %{id: 123456, status: :product_name}}, "Iphone 7s", 123, %{})
#    	{:ok, %{"description" => "Bad Request: chat not found", "error_code" => 400, "ok" => false}}
	"""

  def initCmd({:unknown, internalUser}, _, chatId, from) do
		Davy.BotTelApi.sendMessage(chatId, "I don't know this :(")
	end

  def initCmd({:start, internalUser}, _, chatId, from) do
  	text = "Я помогу вам найти самые выгодные предложения на Авито!
           		Если вы когда-нибуь хотели найти самое выгодное предложение, например Iphone за 10 000, который больше не нужен
           		девушке буржуя, то я тут же отправлю это предложение вам! И даже могу написать владельцу, чтобы попросить его
           		предержать товар. Все, что вам нужно, это указать навзание или категорию товара, который вас интересует.
           		Начем! Укажите название товара или категорию: ()"
		Davy.BotTelApi.sendMessage(chatId, text)
  end

  def initCmd({:error, internalUser}, _, chatId, from) do
  	Davy.BotTelApi.sendMessage(chatId, "Sorry, something went wrong")
  end
end