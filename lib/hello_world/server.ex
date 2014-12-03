defmodule HelloWorld.Server do
  def start_link do
    Plug.Adapters.Cowboy.http HelloWorld.Router, [], port: 7000
  end
end
