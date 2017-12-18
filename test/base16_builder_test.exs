defmodule Base16BuilderTest do
  use ExUnit.Case
  doctest Base16Builder

  test "sources.yaml must exist" do
    assert File.exists?("./sources.yaml")
  end

  test "task_timeout should return @timeout if no env var is set" do
    System.delete_env("BASE16_BUILDER_TASK_TIMEOUT")
    assert(Base16Builder.task_timeout == 60000)
  end

  test "task_timeout should return integer value of env var if it's set" do
    new_timeout = 30000

    System.put_env("BASE16_BUILDER_TASK_TIMEOUT", "#{new_timeout}")
    assert(Base16Builder.task_timeout == new_timeout)

    System.delete_env("BASE16_BUILDER_TASK_TIMEOUT")
  end
end
