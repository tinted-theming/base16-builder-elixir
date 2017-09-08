defmodule SchemeTest do
  use ExUnit.Case
  alias Base16Builder.Scheme
  doctest Scheme

  test "it should be able to parse a scheme" do
    path = "test/fixtures/schemes/default-dark.yaml"
    scheme = Scheme.from_file(path)

    assert scheme.name == "Default Dark"
    assert scheme.author == "Chris Kempson (http://chriskempson.com)"
    assert Enum.at(scheme.bases, 0) == {"base00", "181818"}
    assert Enum.at(scheme.bases, 1) == {"base01", "282828"}
    assert Enum.at(scheme.bases, 2) == {"base02", "383838"}
    assert Enum.at(scheme.bases, 3) == {"base03", "585858"}
    assert Enum.at(scheme.bases, 4) == {"base04", "b8b8b8"}
    assert Enum.at(scheme.bases, 5) == {"base05", "d8d8d8"}
    assert Enum.at(scheme.bases, 6) == {"base06", "e8e8e8"}
    assert Enum.at(scheme.bases, 7) == {"base07", "f8f8f8"}
    assert Enum.at(scheme.bases, 8) == {"base08", "ab4642"}
    assert Enum.at(scheme.bases, 9) == {"base09", "dc9656"}
    assert Enum.at(scheme.bases, 10) == {"base0A", "f7ca88"}
    assert Enum.at(scheme.bases, 11) == {"base0B", "a1b56c"}
    assert Enum.at(scheme.bases, 12) == {"base0C", "86c1b9"}
    assert Enum.at(scheme.bases, 13) == {"base0D", "7cafc2"}
    assert Enum.at(scheme.bases, 14) == {"base0E", "ba8baf"}
    assert Enum.at(scheme.bases, 15) == {"base0F", "a16946"}
  end
end
