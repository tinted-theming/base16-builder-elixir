defmodule Repository do
  @moduledoc """
  Represents a Base 16 repository (either a template or scheme repository)
  """
  @sources_filename "sources.yaml"
  @sources_dir_name "sources"


  @doc """
  Attempts to pull or clone Base16 templates and schemes repositories.
  """
  def init_sources_repos do
     init_sources_repo("templates")
     init_sources_repo("schemes")
  end

  @doc """
  Clones a git repository at `path/name` or pulls it if it exists.
  """
  def update(path, name, url) do
    repo_path = "#{path}/#{name}"

    git_task = Task.async fn() ->

      case File.exists?(repo_path) do
        true ->
          repo = Git.new(repo_path)
          Git.pull(repo)
          repo

        false ->
          {:ok, repo} = Git.clone([url, repo_path])
          repo
      end
    end

    Task.await(git_task)
  end

  defp repo_url_from_sources_yaml(key) do
    yaml = YamlElixir.read_from_file(@sources_filename, atoms: true)
    url = yaml[key]

    if url != nil do
      {:ok, url}
    else
      {:error, "Couldn't parse URL from YAML file"}
    end
  end

  defp init_sources_repo(key) do
    with {:ok, url} <- repo_url_from_sources_yaml(key) do
      update(
        @sources_dir_name,
        key,
        url
      )
    end
  end
end
