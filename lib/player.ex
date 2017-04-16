defmodule IslandsEngine.Player do
  @moduledoc """
  A player has a name, an archipelago and a game board
  """

  alias IslandsEngine.{Board, Coordinate, Archipelago, Player}
  defstruct [name: :none, board: :none, archipelago: :none]

  def start_link(name \\ :none) do
    {:ok, board} = Board.start_link
    {:ok, archipelago} = Archipelago.start_link
    Agent.start_link(fn -> %Player{board: board, archipelago: archipelago, name: name} end)
  end

  def set_name(player, name) do
    Agent.update(player, fn state -> Map.put(state, :name, name) end)
  end

  def to_string(player) do
    "%Player{" <> string_body(player) <> "}"
  end

  defp string_body(player) do
    state = Agent.get(player, &(&1))
    ":name =>" <> name_to_string(state.name) <> ",\n" <>
    ":archipelago =>" <> Archipelago.to_string(state.archipelago) <> ",\n" <>
    ":board =>" <> Board.to_string(state.board)
  end

  defp name_to_string(:none), do: ":none"
  defp name_to_string(name), do: "\"#{name}\""
end
