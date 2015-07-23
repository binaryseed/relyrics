defmodule Mike do
  use Supervisor

  def start_link(), do: Supervisor.start_link(__MODULE__, [])

  def init(_args) do
    [ worker(Joe, []), worker(Robert, []) ]
      |> supervise([strategy: :one_for_one, name: :mike_williams])
  end
end
