defmodule CoordinateTest do
  use ExUnit.Case
  alias IslandsEngine.Coordinate
  doctest Coordinate

  test "Coordinate.new/2 green" do
    assert Coordinate.new(0, 5)
    == {:ok, %Coordinate{row: 0, col: 5}}
  end
  test "Coordinate.new/2  out of bounds" do
    assert Coordinate.new(10, -1)
    == {:error, :invalid_coordinates}
  end
end
