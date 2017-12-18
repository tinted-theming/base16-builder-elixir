defmodule Base16Builder.Scheme do
  alias Base16Builder.Scheme

  defstruct name: "", slug: "", author: "", bases: %{}

  @bases ~w(
    base00
    base01
    base02
    base03
    base04
    base05
    base06
    base07
    base08
    base09
    base0A
    base0B
    base0C
    base0D
    base0E
    base0F
  )

  @doc """
  Returns a list of scheme structs obtained by looking at
  "schemes/**/*.yaml"
  """
  def load_schemes do
    Path.wildcard("schemes/*/*.yaml")
    |> Enum.map(&from_file(&1))
  end

  def from_file(file_path) do
    yaml = YamlElixir.read_from_file(file_path)

    %Scheme{
      name: yaml["scheme"],
      author: yaml["author"],
      slug: Path.basename(file_path, "yaml") |> Slugger.slugify_downcase(),
      bases: Map.new(@bases, fn base -> {base, yaml[base]} end)
    }
  end
end
