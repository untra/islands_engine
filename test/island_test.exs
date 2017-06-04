defmodule IslandTest do
  use ExUnit.Case
  alias IslandsEngine.{Island, Coordinate}
  doctest Island

  test "Island.new/2 green" do
    {:ok, coordinate} = Coordinate.new(1, 1)
    assert Island.new(:square, coordinate)
    == {:ok,
      %Island{
        coordinates: MapSet.new([
          %Coordinate{row: 1, col: 1},
          %Coordinate{row: 2, col: 1},
          %Coordinate{row: 1, col: 2},
          %Coordinate{row: 2, col: 2}
        ]),
        hit_coordinates: MapSet.new()
      }
    }
  end

  test "Island.new/2 :invalid_coordinates" do
    {:ok, coordinate} = Coordinate.new(8, 8)
    assert Island.new(:s_shape, coordinate)
    == {:error, :invalid_coordinates}
  end

  test "Island.new/2 :invalid_island" do
    {:ok, coordinate} = Coordinate.new(5, 3)
    assert Island.new(:q_shape, coordinate)
    == {:error, :invalid_island_type}
  end

  test "Island.overlaps?/2 true" do
    {:ok, coord} = Coordinate.new(2, 4)
    {:ok, dot} = Island.new(:dot, coord)
    {:ok, s_shape} = Island.new(:s_shape, coord)
    assert Island.overlaps?(dot, s_shape)
    == false
  end

  test "Island.overlaps?/2 false" do
    {:ok, coord} = Coordinate.new(2, 4)
    {:ok, l_shape} = Island.new(:l_shape, coord)
    {:ok, s_shape} = Island.new(:s_shape, coord)
    assert Island.overlaps?(l_shape, s_shape)
    == true
  end

  test "Island.forested?/1 true" do
    {:ok, coord} = Coordinate.new(2, 4)
    {:ok, s_shape} = Island.new(:s_shape, coord)
    assert Island.forested?(s_shape)
    == false
  end

  test "Island.forested?/1 false" do
    {:ok, coord} = Coordinate.new(3, 6)
    {:ok, s_shape} = Island.new(:s_shape, coord)
    forested = %{s_shape | hit_coordinates: s_shape.coordinates}
    assert Island.forested?(forested)
    == true
  end

  test "Island.guess/2 :hit" do
    {:ok, coord} = Coordinate.new(3, 3)
    {:ok, l_shape} = Island.new(:l_shape, coord)
    hit_coordinates = MapSet.new([coord])
    assert Island.guess(l_shape, coord)
    == {:hit, %{l_shape | hit_coordinates: hit_coordinates}}
  end

  test "Island.guess/2 :miss" do
    {:ok, coord} = Coordinate.new(3, 3)
    {:ok, guess} = Coordinate.new(4, 3)
    {:ok, atoll} = Island.new(:atoll, coord)
    assert Island.guess(atoll, guess)
    == {:miss, atoll}
  end

  test "Island.types/0 green" do
    assert Island.types()
    == [:square, :dot, :atoll, :l_shape, :s_shape]
  end
end
