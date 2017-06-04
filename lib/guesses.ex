defmodule IslandsEngine.Guesses do
  @moduledoc """
  Guess within a board, containing an island and a guess
  """
  alias __MODULE__
  alias IslandsEngine.Coordinate

  @board_range 0..9
  @enforce_keys [:hits, :misses]

  defstruct [:hits, :misses]

  def new() do
    {:ok, %Guesses{hits: MapSet.new(), misses: MapSet.new()}}
  end

  def add(%Guesses{} = guesses, :hit, %Coordinate{} = coordinate) do
    update_in(guesses.hits, &MapSet.put(&1, coordinate))
  end

  def add(%Guesses{} = guesses, :miss, %Coordinate{} = coordinate) do
    update_in(guesses.misses, &MapSet.put(&1, coordinate))
  end

end
