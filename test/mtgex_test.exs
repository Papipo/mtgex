defmodule MtgexTest do
  use ExUnit.Case
  doctest Mtgex

  test "greets the world" do
    assert Mtgex.hello() == :world
  end
end
