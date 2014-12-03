defmodule HelloWorld.Router do
  use Plug.Router
  import Plug.Conn
  require Logger

  plug Plug.Logger
  plug Plug.Session, store: :ets, key: "_hello_plug_session", secure: true, table: :hello_sessions
  plug :match
  plug :dispatch


  get "/" do
    send_resp conn, 200, "visit /set and /get"
  end


  get "/set" do
    conn = fetch_session(conn)
    str = random_string
    put_session(conn, :ticket_id, str)
    |> send_resp 200, "Set ticket id: #{str}"
  end


  get "/get" do
    conn = fetch_session(conn)
    str = get_session(conn, :ticket_id)
    send_resp conn, 200, "Get ticket id: #{str}"
  end


  match _ do
    send_resp conn, 404, "404 go elsewhere"
  end


  defp random_string do
    Base.hex_encode32(:crypto.strong_rand_bytes(5))
  end

end
