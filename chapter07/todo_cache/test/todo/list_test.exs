defmodule TodoListTest do
  use ExUnit.Case

  test "TodoList initialization" do
    list = Todo.List.new()
    assert ^list = %Todo.List{}
  end

  test "Add new entry" do
    entry = TodoEntry.new(~D[2020-11-12], "Dentist")
  end
end
