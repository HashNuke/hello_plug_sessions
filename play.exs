:ets.new(:sessions, [:named_table, :public, read_concurrency: true])

defmodule MyPlug do
  use Plug.Router
  import Plug.Conn
  require Logger

  plug Plug.Logger
  plug Plug.Session, store: :ets, key: "_hello_session", secure: true, table: :sessions
  # plug :put_secret_key_base
  # plug Plug.Session, store: :cookie,
  #                    key: "_hello_session",
  #                    encryption_salt: "cookie store encryption salt",
  #                    signing_salt: "cookie store signing salt",
  #                    key_length: 64,
  #                    serializer: Poison
  plug :match
  plug :dispatch


  def put_secret_key_base(conn, _) do
    put_in conn.secret_key_base, "-- LONG STRING WITH AT LEAST 64 BYTES -- LONG STRING WITH AT LEAST 64 BYTES --"
  end


  get "/set" do
    conn = fetch_session(conn)
    str = random_string
    put_session(conn, :ticket_id, str)
    |> send_resp 200, "Set: #{str}"
  end


  get "/get" do
    conn = fetch_session(conn)
    str = get_session(conn, :ticket_id)
    send_resp conn, 200, "Get: #{str}"
  end


  match _ do
    send_resp conn, 404, "404 go elsewhere"
  end


  defp random_string do
    Base.hex_encode32(:crypto.strong_rand_bytes(5))
  end

end

x = Plug.Adapters.Cowboy.http MyPlug, [], port: 7000
IO.puts "Running MyPlug with Cowboy on http://localhost:7000"
