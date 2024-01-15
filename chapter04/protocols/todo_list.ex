defmodule TodoEntry do
  defstruct id: nil, date: nil, title: nil

  def new(date, title) do
    %TodoEntry{id: nil, date: date, title: title}
  end
end

defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(), do: %TodoList{}

  def add_entry(todo_list, %TodoEntry{} = entry) do
    new_entry = Map.put(entry, :id, todo_list.auto_id)
    new_entries = Map.put(todo_list.entries, todo_list.auto_id, new_entry)

    %TodoList{todo_list | auto_id: todo_list.auto_id + 1, entries: new_entries}
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.map(fn {_, v} -> v end)
    |> Enum.filter(&(&1.date == date))
  end

  def update_entry(todo_list, entry_id, updater) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error -> todo_list
      {:ok, old_entry} ->
        old_entry_id = old_entry.id
        new_entry = %TodoEntry{id: ^old_entry_id} = updater.(old_entry)
        new_entries = Map.put(todo_list.entries, entry_id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def update_entry(todo_list, %TodoEntry{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
  end
end

defimpl Enumerable, for: TodoList do
  def count(todo_list) do
    {:ok, map_size(todo_list.entries)}
  end
end

defimpl Collectable, for: TodoList do
  def into(original) do
    {original, &into_callback/2}
  end

  defp into_callback(todo_list, {cont, entry}) do
    TodoLista.add_entry(todo_list, entry)
  end

  defp into_callback(todo_list, :done), do: todo_list

  defp into_callback(todo_list, :halt), do: :ok
end
