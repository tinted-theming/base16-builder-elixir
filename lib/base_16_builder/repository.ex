defmodule Base16Builder.Repository do
  @moduledoc """
  Represents a Base 16 repository (either a template or scheme repository)
  """
  alias Base16Builder.Repository
  defstruct path: "", name: "", url: "", git_repo: %Git.Repository{}

  @sources_filename "sources.yaml"
  @sources_dir_name "sources"


  @doc """
  Attempts to pull or clone Base16 templates and schemes repositories.
  """
  def init_sources_repos do
     [
       init_sources_repo("templates"),
       init_sources_repo("schemes")
     ]
  end

  @doc """
  Clones a git repository at `path/name` or pulls it if it exists.
  """
  def update(%Repository{} = repo) do
    repo_path = "#{repo.path}/#{repo.name}"

    git_task = Task.async fn() ->
      case File.exists?(repo_path) do
        true ->
          existing_git_repo = Git.new(repo_path)

          case Git.pull(existing_git_repo) do
            {:ok, existing} -> existing
            {:error, _} -> nil
          end

        false ->
          cloned_git_repo = case Git.clone([repo.url, repo_path]) do
            {:ok, cloned} -> cloned
            {:error, _} -> nil
          end

          cloned_git_repo
      end
    end

    git_repo = Task.await(git_task)

    if git_repo == nil do
      {:error, "Unknown error"}
    else
      Map.put(repo, :git_repo, git_repo)
      {:ok, repo}
    end
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
      update(%Repository{
        path: @sources_dir_name,
        name: key,
        url: url
      })
    end
  end
end
