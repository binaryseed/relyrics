defmodule Joe do
  use GenServer

  def start_link(), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def init(_) do
    words   = Relyric.load_file("data/OTP_dictionary.txt")
    jumbles = Relyric.load_file("data/OTP_jumble.txt")

    dict = words
      |> Enum.flat_map( fn(word) -> [{sort_word(word), word}] end )
      |> Enum.into(%{})

    jumbles
      |> Enum.map( &Joe.unjumble/1 )

    {:ok, dict}
  end

  def unjumble(line), do: GenServer.cast(__MODULE__, {:unjumble, line})

  def handle_cast({:unjumble, line}, dict) do
    IO.puts "? #{line}"
    line
      |> String.split(" ")
      |> Enum.map( &sort_word/1 )
      |> Enum.map( &( Map.get(dict, &1) ) )
      |> permutations
      |> Enum.map( &( Enum.join(&1, " ")) )
      |> Robert.evaluate

    {:noreply, dict}
  end

  def sort_word(word) do
    word
      |> String.split("")
      |> Enum.sort
      |> Enum.join
      |> String.to_atom
  end

  def permutations([]), do: [[]]
  def permutations(list) do
    for h <- list, t <- permutations(list -- [h]), do: [h | t]
  end
end
