defmodule Mtgex.API do
  @endpoint "https://api.magicthegathering.io/v1/cards"

  def start do
    HTTPotion.start
  end

  def fetch_all(options) do
    first_page = build_url(options)
    |> fetch

    remaining_urls_from(first_page, options)
    |> Flow.from_enumerable
    |> Flow.partition
    |> Flow.map(&fetch/1)
    |> Flow.flat_map(&to_card_list(&1, options))
    |> Enum.to_list
    |> Enum.concat(to_card_list(first_page, options))
    |> group_by(options[:group])
  end

  # Builds an URL with @endpoint + set, color and page as query arguments
  defp build_url(options, page \\ 1) do
    query_string = options
    |> Keyword.merge(page: page)
    |> query_string_from([:set, :colors, :page])

    [@endpoint, query_string]
    |> Enum.join("?")
  end

  # Builds a query string from only the specified keyword arguments
  defp query_string_from(options, names) do
    options
    |> Keyword.take(names)
    |> Enum.map(fn({name, value}) ->
      "#{name}=#{value}"
    end)
    |> Enum.join("&")
  end

  # Fetches an HTTP URL by GET
  defp fetch(url) do
    HTTPotion.get(url, timeout: 10_000)
  end

  # Returns a stream of urls from page 2 to the last one
  defp remaining_urls_from(first_page, options) do
    {total_count, _} = Integer.parse(first_page.headers["Total-Count"])
    {page_size, _}   = Integer.parse(first_page.headers["Page-Size"])
    remaining_pages  = trunc(total_count / page_size)

    Stream.map(1..remaining_pages, &build_url(options, &1 + 1))
  end

  defp to_card_list(result, options) do
    result.body
    |> Poison.decode!
    |> Map.get("cards")
    |> Enum.reject(&has_other_colors?(&1, options[:colors]))
  end

  defp has_other_colors?(card, nil) do
    false
  end

  defp has_other_colors?(card, colors) do
    has = card["colors"]
    |> Enum.map(&String.downcase/1)

    wants = String.split(colors, "|")

    Enum.count(has -- wants) > 0
  end

  defp group_by(cards, nil), do: cards
  defp group_by(cards, []),  do: cards

  defp group_by(cards, [head | tail]) do
    cards
    |> Enum.group_by(&(&1[head]))
    |> Enum.map(fn({key, cards}) ->
      {key, group_by(cards, tail)}
    end)
    |> Enum.into(%{})
  end

  defp group_by(cards, groups) do
    group_by(cards, String.split(groups, ","))
  end
end
