defmodule TodoEntry do
  defstruct id: nil, date: nil, title: nil

  def new(date, title) do
    %TodoEntry{id: nil, date: date, title: title}
  end

  def new(%{date: date, title: title}) do
    %TodoEntry{id: nil, date: date, title: title}
  end
end

defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(entries) do
    entries
    |> Enum.map(&TodoEntry.new(&1))
    |> Enum.reduce(%TodoList{}, &add_entry(&2, &1))
  end

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

  def delete_entry(todo_list, entry_id) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error -> todo_list
      {:ok, _} ->
        new_entries = Map.delete(todo_list.entries, entry_id)
        %TodoList{todo_list | entries: new_entries}
    end
  end
end


# as an example:
e1 = TodoEntry.new(~D[2020-11-12], "Dentist")
e2 = TodoEntry.new(~D[2020-11-12], "shopping")
e3 = TodoEntry.new(~D[2020-11-15], "Gym")

todo = TodoList.new()
todo = TodoList.add_entry(todo, e1)
todo = TodoList.add_entry(todo, e2)
todo = TodoList.add_entry(todo, e3)

# todo
%TodoList{
  auto_id: 3,
  entries: %{
    1 => %TodoEntry{id: 1, date: ~D[2020-11-12], title: "Dentist"},
    2 => %TodoEntry{id: 2, date: ~D[2020-11-12], title: "shopping"}
  }
}

updater = fn x -> %TodoEntry{id: x.id, date: x.date, title: "reading"} end

todo = TodoList.update_entry(todo, 5, updater)
# result
%TodoList{
  auto_id: 3,
  entries: %{
    1 => %TodoEntry{id: 1, date: ~D[2020-11-12], title: "Dentist"},
    2 => %TodoEntry{id: 2, date: ~D[2020-11-12], title: "shopping"}
  }
}

todo = TodoList.update_entry(todo, 1, updater)
# result
%TodoList{
  auto_id: 3,
  entries: %{
    1 => %TodoEntry{id: 1, date: ~D[2020-11-12], title: "reading"},
    2 => %TodoEntry{id: 2, date: ~D[2020-11-12], title: "shopping"}
  }
}

entries = [
  %{date: ~D[2020-11-13], title: "cooking food"},
  %{date: ~D[2020-11-14], title: "biking"},
  %{date: ~D[2020-11-17], title: "airport"}
]
