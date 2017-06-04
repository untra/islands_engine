defmodule IslandsEngine.Island do
  @moduledoc """
  An island with many coordinates, represented with a list
  """
  alias __MODULE__
  alias IslandsEngine.Coordinate

  @enforce_keys [:coordinates, :hit_coordinates]
  @island_types [:square, :dot, :atoll, :l_shape, :s_shape]

  defstruct [:coordinates, :hit_coordinates]

  def new(type, %Coordinate{} = upper_left) do
    with  {:ok, [_|_] = offset} <- offsets(type),
          %MapSet{} = coordinates <- add_coordinates(offset, upper_left)
    do
      {:ok, %Island{coordinates: coordinates, hit_coordinates: MapSet.new()}}
    else
      error -> error
    end
  end

  def add_coordinates(offsets, upper_left) do
    Enum.reduce_while(offsets, MapSet.new(), fn offset, acc ->
      add_coordinate(acc, upper_left, offset)
    end)
  end

  def overlaps?(%Island{} = existing, %Island{} = tentative) do
    not MapSet.disjoint?(existing.coordinates, tentative.coordinates)
  end

  def forested?(%Island{} = island) do
    MapSet.equal?(island.coordinates, island.hit_coordinates)
  end


  @doc """
  Given an island and a coordinate, returns a tuple indicating whether the coordinate
  is within the island coordinates (:hit or :miss), and the updated island respectively
  """
  def guess(%Island{} = island, %Coordinate{} = coordinate) do
    case MapSet.member?(island.coordinates, coordinate) do
      true ->
        hit_coordinates = MapSet.put(island.hit_coordinates, coordinate)
        {:hit, %{island | hit_coordinates: hit_coordinates}}
      false -> {:miss, island}
    end
  end

  def types(), do: @island_types

  # private

  defp offsets(:square), do: {:ok, [{0, 0}, {0, 1}, {1, 0}, {1, 1}]}
  defp offsets(:atoll),  do: {:ok, [{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 1}]}
  defp offsets(:dot),    do: {:ok, [{0, 0}]}
  defp offsets(:l_shape), do: {:ok, [{0, 0}, {1, 0}, {2, 0}, {2, 1}]}
  defp offsets(:s_shape), do: {:ok, [{0, 1}, {0, 2}, {1, 0}, {1, 1}]}
  defp offsets(_), do: {:error, :invalid_island_type}

  defp add_coordinate(coordinates, %{row: row, col: col},
  {row_offset, col_offset}) do
    case Coordinate.new(row + row_offset, col + col_offset) do
      {:ok, coordinate} ->
        {:cont, MapSet.put(coordinates, coordinate)}
      {:error, err} ->
        {:halt, {:error, err}}
    end
  end

  # def start_link() do
  #   Agent.start_link(fn -> [] end)
  # end

  # def coordinates(island) do
  #   Agent.get(island, fn state -> state end)
  # end

  # def replace_coordinates(island, new_coordinates) when is_list(new_coordinates) do
  #   Agent.update(island, fn _state -> new_coordinates end)
  # end

  # def forested?(island) do
  #   island
  #   |> coordinates
  #   |> Enum.all?(fn coord -> Coordinate.hit?(coord) end)
  # end

  # def to_string(island) do
  #   "[" <> coordinate_strings(island) <> "]"
  # end

  # defp coordinate_strings(island) do
  #   island
  #   |> coordinates
  #   |> Enum.map(fn coord -> Coordinate.to_string(coord) end)
  #   |> Enum.join(", ")
  # end

end
