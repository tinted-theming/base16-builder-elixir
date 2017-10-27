defmodule RepositoryTest do
  use ExUnit.Case
  alias Base16Builder.Repository
  doctest Repository

  test "it should be able to acquire sources, templates, and schemes repos" do
    # Remove all paths that should be created by calling init
    File.rm("sources")
    File.rm("schemes")
    File.rm("templates")

    Repository.init()

    assert File.exists?("sources")
    assert File.exists?("schemes")
    assert File.exists?("templates")

    File.rm("sources")
    File.rm("schemes")
    File.rm("templates")
  end
end
