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

  def entries(todo_list) do
    todo_list.entries
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

defmodule TodoServer do
  def start() do
    spawn(fn -> loop(TodoList.new()) end)
  end

  def add_entry(todo_server, entry) do
    send(todo_server, {:add_entry, entry})
  end

  def entries(todo_server) do
    send(todo_server, {:entries, self()})

    receive do
      {:entries, todos_list} -> todos_list
    end
  end

  def entries(todo_server, date) do
    send(todo_server, {:entries, date, self()})

    receive do
      {:filtered_entries, list} -> list
    end
  end

  defp loop(todo_list) do
    new_todo_list = receive do
      request -> process_request(todo_list, request)
    end

    loop(new_todo_list)
  end

  defp process_request(todo_list, {:add_entry, entry}) do
    TodoList.add_entry(todo_list, entry)
  end

  defp process_request(todo_list, {:entries, caller}) do
    send(caller, {:entries, TodoList.entries(todo_list)})
    todo_list
  end

  defp process_request(todo_list, {:entries, date, caller}) do
    send(caller, {:filtered_entries, TodoList.entries(todo_list, date)})
    todo_list
  end
end
