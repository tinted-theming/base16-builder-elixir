defmodule TemplateTest do
  use ExUnit.Case
  alias Base16Builder.Template
  alias Base16Builder.Scheme
  doctest Template

  test "it should render a template" do
    scheme_path = "test/fixtures/schemes/default-dark.yaml"
    scheme = Scheme.from_file(scheme_path)

    template_path = "test/fixtures/templates"

    template = %Template{
      config_file_path: Path.join(template_path, "config.yaml"),
      directory: "test/fixtures/templates"
    }

    rendered_file = "out/colors/base16-default-dark.vim"
    File.rm(rendered_file)

    Template.render(template, scheme)

    assert File.exists?(rendered_file)
    File.rm(rendered_file)
  end
end
