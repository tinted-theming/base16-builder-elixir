defmodule Base16Builder.Template do
  def render(scheme = %Base16Builder.Scheme{}) do
    nil
  alias Base16Builder.Template
  alias Base16Builder.Scheme

  defstruct config_file_path: "",
            directory: ""

  def load_templates do
    Path.wildcard("templates/**/templates")
    |> Enum.map(fn(path) ->
      %Template{
        config_file_path: Path.join(path, "config.yaml"),
        directory: path
      }
    end)
  end
  end


  defp build_template_data(scheme = %Base16Builder.Scheme{}) do
    data = %{
      "scheme-name" => scheme.name,
      "scheme-author" => scheme.author,
      "scheme-slug" => scheme.slug,
    }

    for {base, value} <- scheme.bases do
      num_colors = 255

      # Extract R, G, and B color components from Hex
      rgb =
        String.upcase(value)
        |> ColorUtils.hex_to_rgb()

      %{
        "#{base}-hex-r" => String.slice(value, 0, 2),
        "#{base}-hex-g" => String.slice(value, 2, 2),
        "#{base}-hex-b" => String.slice(value, 4, 2),
        "#{base}-rgb-r" => rgb.red,
        "#{base}-rgb-g" => rgb.green,
        "#{base}-rgb-b" => rgb.blue,
        "#{base}-dec-r" => rgb.red / num_colors,
        "#{base}-dec-g" => rgb.green / num_colors,
        "#{base}-dec-b" => rgb.blue / num_colors,
      }
    end
    |> Enum.reduce(data, fn (map, accumulator) ->
         Map.merge(accumulator, map)
       end)
  end
end
