defmodule Mtgex.APITest do
  use ExUnit.Case, async: true
  use ExVCR.Mock

  setup_all do
    Mtgex.API.start
    :ok
  end

  @tag timeout: 180_000
  test "Get all cards grouped by set" do
    use_cassette "all_cards", match_requests_on: [:query] do
      result = Mtgex.API.fetch_all(group: "set")

      assert result |> Map.keys |> Enum.count == 219 # Number of sets (keys)
      assert result["LEB"] |> Enum.count == 302 # Number of cards in Beta
    end
  end

  @tag timeout: 180_000
  test "Get all cards grouped by set then by rarity" do
    use_cassette "all_cards", match_requests_on: [:query] do
      result = Mtgex.API.fetch_all(group: "set,rarity")
      assert result |> Map.keys |> Enum.count == 219 # Number of sets (keys)
      assert result["LEA"]["Rare"] |> Enum.count == 116 # Number of rares in alpha
    end
  end

  @tag timeout: 180_000
  test "Get red and blue cards from Khans or Tarkir" do
    use_cassette "khans_red_and_blue", match_requests_on: [:query] do
      result = Mtgex.API.fetch_all(set: "KTK", colors: "red|blue")
      assert Enum.count(result) == 67
    end
  end
end
