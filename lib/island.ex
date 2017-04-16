defmodule IslandsEngine.Island do
  @moduledoc """
  An island with many coordinates, represented with a list
  """
  alias IslandsEngine.Coordinate

  def start_link() do
    Agent.start_link(fn -> [] end)
  end

  def coordinates(island) do
    Agent.get(island, fn state -> state end)
  end

  def replace_coordinates(island, new_coordinates) when is_list(new_coordinates) do
    Agent.update(island, fn _state -> new_coordinates end)
  end

  def forested?(island) do
    island
    |> coordinates
    |> Enum.all?(fn coord -> Coordinate.hit?(coord) end)
  end

  def to_string(island) do
    "[" <> coordinate_strings(island) <> "]"
  end

  defp coordinate_strings(island) do
    island
    |> coordinates
    |> Enum.map(fn coord -> Coordinate.to_string(coord) end)
    |> Enum.join(", ")
  end

end
