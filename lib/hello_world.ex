defmodule HelloWorld do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    :ets.new(:hello_sessions, [:named_table, :public, read_concurrency: true])

    children = [
      # Define workers and child supervisors to be supervised
      # worker(HelloWorld.Worker, [arg1, arg2, arg3])
      worker(HelloWorld.Server, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelloWorld.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
