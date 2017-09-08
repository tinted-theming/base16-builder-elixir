defmodule Base16BuilderTest do
  use ExUnit.Case
  doctest Base16Builder

  test "sources.yaml must exist" do
    assert File.exists?("./sources.yaml")
  end
end
