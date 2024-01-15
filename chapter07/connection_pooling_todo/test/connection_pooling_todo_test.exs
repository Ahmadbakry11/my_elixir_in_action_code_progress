defmodule ConnectionPoolingTodoTest do
  use ExUnit.Case
  doctest ConnectionPoolingTodo

  test "greets the world" do
    assert ConnectionPoolingTodo.hello() == :world
  end
end
