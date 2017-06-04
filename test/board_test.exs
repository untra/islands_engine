defmodule BoardTest do
  use ExUnit.Case
  alias IslandsEngine.{Board, Island, Coordinate}
  doctest Board

  defp quick_add_island(board, type, col, row) do
    {:ok, coord} = Coordinate.new(col, row)
    {:ok, island} = Island.new(type, coord)
    {:ok, new_board } = Board.position_island(board, type, island)
    new_board
  end

  defp quick_populated_board() do
    {:ok, board} = Board.new()
    board
    |> quick_add_island(:square, 0, 0)
    |> quick_add_island(:atoll, 0, 2)
    |> quick_add_island(:dot, 1, 2)
    |> quick_add_island(:l_shape, 4, 4)
    |> quick_add_island(:s_shape, 6, 7)
  end

  test "Board.new/0 green" do
    assert Board.new()
    == {:ok, %{}}
  end

  test "Board.position_island/3 green" do
    key = :atoll
    {:ok, board} = Board.new()
    {:ok, coord1} = Coordinate.new(2, 4)
    {:ok, island1} = Island.new(key, coord1)
    {:ok, coord2} = Coordinate.new(3, 4)
    {:ok, island2} = Island.new(key, coord2)
    new_board = Map.put(board, key, island1)
    assert Board.position_island(board, key, island1)
    == {:ok, new_board}
    assert Board.position_island(new_board, key, island2)
    == {:ok, Map.put(new_board, key, island2)}
  end

  test "Board.position_island/3 :overlapping_island" do
    {:ok, board} = Board.new()
    {:ok, coord1} = Coordinate.new(2, 4)
    {:ok, island1} = Island.new(:atoll, coord1)
    {:ok, coord2} = Coordinate.new(3, 4)
    {:ok, island2} = Island.new(:square, coord2)
    new_board = quick_add_island(board, :atoll, 2, 4)
    assert Board.position_island(board, :atoll, island1)
    == {:ok, new_board}
    assert Board.position_island(new_board, :square, island2)
    == {:error, :overlapping_island}
  end

  test "Board.all_islands_positioned?/1 tfalse" do
    {:ok, board} = Board.new()
    assert Board.all_islands_positioned?(board)
    == false
  end

  test "Board.all_islands_positioned?/1 true" do
    new_board = quick_populated_board()
    assert Board.all_islands_positioned?(new_board)
    == true
  end

  test "Board.guess/2 :miss" do
    {:ok, miss_coord} = Coordinate.new(0, 7)
    new_board = quick_populated_board()
    assert Board.guess(new_board, miss_coord)
    == {:miss, :none, :no_win, new_board}
  end
end
