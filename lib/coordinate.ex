defmodule IslandsEngine.Coordinate do
  @moduledoc """
  Coordinate within a board, containing an island and a guess
  """
  alias __MODULE__

  @board_range 0..9
  @enforce_keys [:row, :col]

  defstruct [:row, :col]

  def new(row, col)
  when row in(@board_range) and col in(@board_range), do:
    {:ok, %Coordinate{row: row, col: col}}

  def new(row, col), do:
    {:error, :invalid_coordinates}


















  # defstruct in_island: :none, guessed?: false

  # def start_link() do
  #   Agent.start_link(fn -> %Coordinate{} end)
  # end

  # def guessed?(coordinate) do
  #   Agent.get(coordinate, fn state -> state.guessed? end)
  # end

  # def island(coordinate) do
  #   Agent.get(coordinate, fn state -> state.in_island end)
  # end

  # def hit?(coordinate) do
  #   in_island?(coordinate) && guessed?(coordinate)
  # end

  # def in_island?(coordinate) do
  #   case island(coordinate) do
  #     :none -> false
  #     _     -> true
  #   end
  # end

  # def guess(coordinate) do
  #   Agent.update(coordinate, fn state -> Map.put(state, :guessed?, true) end)
  # end

  # def set_in_island(coordinate, value) when is_atom(value) do
  #   Agent.update(coordinate, fn state -> Map.put(state, :in_island, value) end)
  # end

  # def to_string(coordinate) do
  #   "(in_island:#{island(coordinate)}, guessed:#{guessed?(coordinate)})"
  # end

end
