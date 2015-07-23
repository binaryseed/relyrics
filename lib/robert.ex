defmodule Robert do
  use GenServer

  def start_link(), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)
  def init(_) do
    sums = Relyric.load_file("data/OTP_sums.txt")
      |> Enum.flat_map( fn(sum) -> [{sum, true}] end )
      |> Enum.into(%{})

    {:ok, sums}
  end

  def evaluate(line), do: GenServer.cast(__MODULE__, {:evaluate, line})

  def handle_cast({:evaluate, lines}, sums) do

    IO.puts "- #{Enum.count lines} #{List.first lines}"
    Enum.each lines, fn (line) ->
      checksum = line |> :crypto.md5 |> Base.encode16(case: :lower)

      if Map.has_key?(sums, checksum) do
        IO.puts "= #{line}"
      end
    end
    IO.puts "/"

    {:noreply, sums}
  end
end
