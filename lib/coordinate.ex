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
    {:error, :invalid_coordinate}

end
