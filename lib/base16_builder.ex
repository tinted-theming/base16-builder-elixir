defmodule Base16Builder do
  @moduledoc """
  Documentation for Base16Builder.
  """

  alias Base16Builder.Scheme
  alias Base16Builder.Template

  def update do
    Base16Builder.Repository.init
  end

  def build do
    build(required_repos_exist?())
  end

  def build(_repos_exist = true) do
    schemes = Scheme.load_schemes
    templates = Template.load_templates

    tasks =
      for scheme <- schemes do
        for template <- templates do
          Task.async(fn ->
            Template.render(template, scheme)
          end)
        end
      end
    |> List.flatten
    |> Enum.map(&Task.await(&1))

      IO.puts inspect(tasks)
  end

  def build(_repos_exist = false) do
    {:error, "Repos don't exist"}
  end

  def required_repos_exist? do
    File.exists?("./schemes/") && File.exists?("./templates/")
  end
end
