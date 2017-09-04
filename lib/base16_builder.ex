defmodule Base16Builder do
  @moduledoc """
  Documentation for Base16Builder.
  """

  alias Base16Builder.Scheme
  alias Base16Builder.Template

  @doc """
  Updates base16 repositories by cloning or pulling.
  """
  def update do
    Base16Builder.Repository.init
  end

  @doc """
  Builds base16 repos into ./out/ and calles update() if repos don't exist.
  """
  def build do
    build(required_repos_exist?())
  end

  defp build(_repos_exist = true) do
    schemes = Scheme.load_schemes
    templates = Template.load_templates

    for scheme <- schemes do
      for template <- templates do
        Task.async(fn ->
          Template.render(template, scheme)
        end)
      end
    end
    |> List.flatten
    |> Enum.map(&Task.await(&1))

    IO.puts("Done.")
  end

  defp build(_repos_exist = false) do
    update()
    build()
  end

  defp required_repos_exist? do
    File.exists?("./schemes/") && File.exists?("./templates/")
  end
end
