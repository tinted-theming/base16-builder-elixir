defmodule Base16Builder.Repository do
  @moduledoc """
  Represents a Base 16 repository (either a template or scheme repository)
  """
  alias Base16Builder.Repository
  defstruct path: "", name: "", url: "", git_repo: %Git.Repository{}

  @sources_filename "sources.yaml"
  @sources_dir_name "sources"
  @task_timeout 30000


  def init do
    init_sources_repos()
    init_templates()
    init_schemes()
  end

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
  Attempts to pull or clone every template repo listed in the templates
  YAML file.
  """
  def init_templates do
    repos_from_yaml_list("sources/templates/list.yaml",
                         "templates")
  end

  @doc """
  Attempts to pull or clone every scheme repo listed in the schemes
  YAML file.
  """
  def init_schemes do
    repos_from_yaml_list("sources/schemes/list.yaml",
                         "schemes")
  end

  @doc """
  Clones a git repository at `path/name` or pulls it if it exists.
  """
  defp update(%Repository{} = repo) do
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

    git_repo = Task.await(git_task, @task_timeout)

    if git_repo == nil do
      {:error, "Unknown error"}
    else
      Map.put(repo, :git_repo, git_repo)
      {:ok, repo}
    end
  end

  defp repo_url_from_sources_yaml(key) do
    yaml = YamlElixir.read_from_file(@sources_filename)
    url = yaml[key]

    if url != nil do
      {:ok, url}
    else
      {:error, "Couldn't parse URL from YAML file"}
    end
  end

  @doc """
    Reads a YAML list (either templates or schemes) and initialized
    repos based on the content.
  """
  defp repos_from_yaml_list(yaml_path, repo_path) do
    case File.exists?(yaml_path) do
      true ->
        repos_data = YamlElixir.read_from_file(yaml_path)

        for {k, v} <- repos_data do
          update(%Repository{
            path: repo_path,
            name: k,
            url: v
          })
        end
      false ->
        {:error, :enoent}
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
