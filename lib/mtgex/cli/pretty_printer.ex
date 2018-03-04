defmodule Mtgex.CLI.PrettyPrinter do
  def print(cards) when is_list(cards) do
    cards
    |> Enum.map(&(&1["name"]))
    |> Enum.each(&IO.puts/1)
  end

  def print(cards) when is_map(cards) do
    Enum.each(cards, fn({group, cards}) ->
      IO.puts String.duplicate("*", String.length(group))
      IO.puts group
      IO.puts String.duplicate("*", String.length(group))
      IO.puts ""

      print(cards)
      IO.puts ""
    end)
  end
end
