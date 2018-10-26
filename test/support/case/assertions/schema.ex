defmodule Absinthe.Case.Assertions.Schema do
  import ExUnit.Assertions

  def load_schema(name) do
    Code.require_file("test/support/fixtures/dynamic/#{name}.exs")
  end

  @doc """
  Assert a schema error occurs.

  ## Examples

  ```
  iex> assert_schema_error("schema-name", [%{rule: Absinthe.Schema.Rule.TheRuleHere, data: :bar}])
  ```
  """
  def assert_schema_error(schema_name, patterns) do
    err =
      assert_raise Absinthe.Schema.Error, fn ->
        load_schema(schema_name)
      end

    patterns
    |> Enum.filter(fn pattern ->
      assert Enum.find(err.phase_errors, fn error ->
               Map.take(error, [:phase, :extra, :locations]) == pattern
             end),
             "Could not find error detail pattern #{inspect(pattern)}\n\nin\n\n#{
               inspect(err.phase_errors)
             }"
    end)

    assert length(patterns) == length(err.phase_errors)
  end

  def assert_notation_error(name) do
    assert_raise(Absinthe.Schema.Notation.Error, fn ->
      load_schema(name)
    end)
  end
end
