defmodule Base16Builder.Template do
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

  def render(template = %Template{}, scheme = %Scheme{}) do
    config = YamlElixir.read_from_file(template.config_file_path)

    for {k, v} <- config do
      template_data = build_template_data(scheme)

      template_file = Path.join(template.directory, "#{k}.mustache")
      rendered_filename = "base16-#{scheme.slug}#{v["extension"]}"
      rendered_dir = Path.join("out", v["output"])

      rendered_template = Mustache.render(File.read(template_file), template_data)

      File.mkdir_p(rendered_dir)

      rendered_file = Path.join(rendered_dir, rendered_filename)

      IO.puts "building #{rendered_file}"
      File.write(rendered_file, rendered_template)
    end
  end


  defp build_template_data(scheme = %Scheme{}) do
    # Using charlists for keys because we'll use an Erlang library for rendering
    # Mustache templates.
    data = %{
      'scheme-name' => scheme.name,
      'scheme-author' => scheme.author,
      'scheme-slug' => scheme.slug,
    }

    for {base, value} <- scheme.bases do
      num_colors = 255

      # Extract R, G, and B color components from Hex
      rgb =
        String.upcase(value)
        |> ColorUtils.hex_to_rgb()

      %{
        '#{base}-hex' => value,
        '#{base}-hex-r' => String.slice(value, 0, 2),
        '#{base}-hex-g' => String.slice(value, 2, 2),
        '#{base}-hex-b' => String.slice(value, 4, 2),
        '#{base}-rgb-r' => round(rgb.red),
        '#{base}-rgb-g' => round(rgb.green),
        '#{base}-rgb-b' => round(rgb.blue),
        '#{base}-dec-r' => rgb.red / num_colors,
        '#{base}-dec-g' => rgb.green / num_colors,
        '#{base}-dec-b' => rgb.blue / num_colors,
      }
    end
    |> Enum.reduce(data, fn (map, accumulator) ->
         Map.merge(accumulator, map)
       end)
  end
end
