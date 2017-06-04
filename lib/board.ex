defmodule IslandsEngine.Board do
  @moduledoc """
  A game board with many coordinates, represented with a map
  """

  alias __MODULE__
  alias IslandsEngine.{Coordinate, Island}

  def new() do
    {:ok, %{}}
  end

  def position_island(board, key, %Island{} = island) do
    case overlaps_existing_island?(board, key, island) do
      true -> {:error, :overlapping_island}
      false -> {:ok, Map.put(board, key, island)}
    end
  end

  def all_islands_positioned?(board) do
    Enum.all?(Island.types, &(Map.has_key?(board, &1)))
  end

  def guess(board, %Coordinate{} = coordinate) do
    board
    |> check_all_islands(coordinate)
    |> guess_response(board)
  end

  # private

  defp overlaps_existing_island?(board, new_key, new_island) do
    Enum.any?(board, fn {key, island} ->
      key != new_key and Island.overlaps?(island, new_island)
    end)
  end

  defp check_all_islands(board, %Coordinate{} = coordinate) do
    Enum.find_value(board, {:miss, nil}, fn {key, island} ->
      case Island.guess(island, coordinate) do
        {:hit, found_island} -> {key, found_island}
        {:miss, _} -> false
      end
    end)
  end

  defp guess_response({key, %Island{} = island}, board) do
    updated_board = %{board | key => island}
    forested = if(Island.forested?(island), do: key, else: :none)
    has_won = win_check(updated_board)
    {:hit, forested, has_won, updated_board}
  end

  defp guess_response({:miss, _}, board) do
    {:miss, :none, :no_win, board}
  end

  defp win_check(board) do
    if Enum.all?(Island.types, fn type ->
      type
      |> Board.fetch!
      |> Island.forested?
    end) do
      :win
    else
      :no_win
    end
  end

  # @letters ~W(a b c d e f g h i j)
  # @numbers Enum.to_list(0..9)

  # def keys do
  #   for letter <- @letters, number <- @numbers do
  #     String.to_atom("#{letter}#{number}")
  #   end
  # end

  # def start_link do
  #   Agent.start_link(fn -> initialized_board() end)
  # end

  # def get_coordinate(board, key) when is_atom key do
  #   Agent.get(board, fn board -> board[key] end)
  # end

  # def guess_coordinate(board, key) do
  #   board
  #   |> get_coordinate(key)
  #   |> Coordinate.guess
  # end

  # def coordinate_hit?(board, key) do
  #   board
  #   |> get_coordinate(key)
  #   |> Coordinate.hit?
  # end

  # def set_coordinate_in_island(board, key, island) do
  #   board
  #   |> get_coordinate(key)
  #   |> Coordinate.set_in_island(island)
  # end

  # def coordinate_island(board, key) do
  #   board
  #   |> get_coordinate(key)
  #   |> Coordinate.island
  # end

  # defp initialized_board() do
  #   Enum.reduce(keys(), %{}, fn(key, board) ->
  #     {:ok, coord} = Coordinate.start_link
  #     Map.put_new(board, key, coord)
  #   end)
  # end

  # def to_string(board) do
  #   "%{" <> string_body(board) <> "}"
  # end

  # defp string_body(board) do
  #   Enum.reduce(keys(), "", fn(key, acc) ->
  #     coord = get_coordinate(board, key)
  #     acc <> "#{key} => #{Coordinate.to_string(coord)},\n"
  #   end)
  # end
end
