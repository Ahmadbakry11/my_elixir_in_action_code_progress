defmodule MultiDict do
  def new(), do: %{}

  def add(dict, entry) do
    Map.update(dict, entry.date, [entry], &[entry | &1])
  end

  def get(dict, key) do
    Map.get(dict, key, [])
  end
end

defmodule TodoList do
  def new(), do: MultiDict.new()

  def add_entry(todo_list, entry) do
    MultiDict.add(todo_list, entry)
  end

  def entries(todo_list, date) do
    MultiDict.get(todo_list, date)
  end
end
