defmodule Mtgex.CLI do

  def main(args \\ []) do
    args
    |> parse_args
    |> fetch_all
    |> pretty_print
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args, switches: switches())
    options
  end

  defp switches do
    [
      set:    :string,
      group:  :string,
      colors: :string
    ]
  end

  defp fetch_all(options) do
    Mtgex.API.fetch_all(options)
  end

  defp pretty_print(cards) do
    Mtgex.CLI.PrettyPrinter.print(cards)
  end
end
