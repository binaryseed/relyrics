defmodule Relyric do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Mike, [])
    ]
    opts = [strategy: :one_for_one, name: :mike_williams]

    Supervisor.start_link(children, opts)
  end

  def load_file(filename) do
    filename
    |> File.stream!
    |> Enum.map( &String.strip/1 )
  end
end
