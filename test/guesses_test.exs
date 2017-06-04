defmodule GuessesTest do
  use ExUnit.Case
  alias IslandsEngine.{Guesses, Coordinate}
  doctest Guesses

  test "Guesses.new/0 green" do
    assert Guesses.new()
    == {:ok, %Guesses{hits: MapSet.new(), misses: MapSet.new()}}
  end

  test "Guesses.add/3 hit" do
    {:ok, guesses} = Guesses.new()
    {:ok, coord} = Coordinate.new(1, 1)
    new_guesses = Guesses.add(guesses, :hit, coord)
    assert new_guesses.hits
    == MapSet.new([coord])
  end

  test "Guesses.add/3 miss" do
    {:ok, guesses} = Guesses.new()
    {:ok, coord} = Coordinate.new(1, 1)
    new_guesses = Guesses.add(guesses, :miss, coord)
    assert new_guesses.misses
    == MapSet.new([coord])
  end
end
