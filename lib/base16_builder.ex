defmodule Base16Builder do
  @moduledoc """
  Documentation for Base16Builder.
  """

  alias Base16Builder.Scheme
  alias Base16Builder.Template

  @timeout 60000

  @doc """
  Updates base16 repositories by cloning or pulling.
  """
  def update do
    Base16Builder.Repository.init()
  end

  @doc """
  Builds base16 repos into ./out/ and calles update() if repos don't exist.
  """
  def build do
    build(required_repos_exist?())
  end

  @doc """
  Returns the integer value of the environment variable
  BASE16_BUILDER_TASK_TIMEOUT or @timeout.
  """
  def task_timeout do
    env_timeout = System.get_env("BASE16_BUILDER_TASK_TIMEOUT")

    if env_timeout, do: String.to_integer(env_timeout), else: @timeout
  end

  defp build(_repos_exist = true) do
    schemes = Scheme.load_schemes()
    templates = Template.load_templates()

    for scheme <- schemes do
      for template <- templates do
        Task.async(fn ->
          Template.render(template, scheme)
        end)
      end
    end
    |> List.flatten()
    |> Enum.map(&Task.await(&1, task_timeout()))

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
