defmodule DsaExTest do
  use ExUnit.Case
  doctest DsaEx

  test "greets the world" do
    assert DsaEx.dsa() == :data_structures_and_algorithms
  end
end
