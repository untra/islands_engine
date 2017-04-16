defmodule IslandsEngine.Archipelago do
  @moduledoc """
  an Archipelago has many islands, represented with a struct
  Called an island_set in the official tutorial
  """

  alias IslandsEngine.{Island, Archipelago}

  defstruct [atoll: :none, dot: :none, l_shape: :none, s_shape: :none, square: :none]

  def start_link() do
    Agent.start_link(fn -> initialized_archipelago() end)
  end

  def to_string(archipelago) do
    "%Archipelago{" <> string_body(archipelago) <> "}"
  end

  defp string_body(archipelago) do
    Enum.reduce(keys(), "", fn(key, acc) ->
      island = Agent.get(archipelago, &(Map.fetch!(&1, key)))
      acc <> "#{key} => " <> Island.to_string(island) <> "\n"
    end)
  end

  defp initialized_archipelago() do
    Enum.reduce(keys(), %Archipelago{}, fn(key, island_set) ->
      {:ok, island} = Island.start_link
      Map.put(island_set, key, island)
    end)
  end

  defp keys() do
    %Archipelago{}
    |> Map.from_struct
    |> Map.keys
  end

end
