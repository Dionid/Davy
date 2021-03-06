defmodule Example.HelloWorldPlug do
  @moduledoc false
  import Plug.Conn

  def init(options), do: options

  def call(conn, _options) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello World!")
  end

end