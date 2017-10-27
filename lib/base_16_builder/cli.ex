defmodule Base16Builder.CLI do
  @name "base16_builder"
  @description ~s"""
  Acquires git repositories containing templates and schemes to build base16
  themes as defined in the builder guidelines:
  https://github.com/chriskempson/base16/blob/master/builder.md
  """

  def main(args \\ []) do
    args
    |> parse_args
    |> process
  end

  defp parse_args(args) do
    Enum.at(args, 0)
  end

  defp process(command) do
    case command do
      "update" -> Base16Builder.update()
      "help" -> print_help_message()
      "build" -> Base16Builder.build()
      _ -> Base16Builder.build()
    end
  end

  defp print_help_message do
    IO.puts("""
    #{@name}

    #{@description}

    Usage:
    base16_builder \t\t# Runs the build command.
    base16_builder build \t# Builds Base16 themes, runs update if required repositories don't exist.
    base16_builder update \t# Re-acquires git repositories or creates them if they don't exist.
    base16_builder help \t# Prints this help message.
    """)
  end
end
