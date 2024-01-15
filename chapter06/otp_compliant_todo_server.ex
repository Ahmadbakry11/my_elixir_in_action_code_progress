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
  use GenServer
  defstruct auto_id: 1, entries: %{}

  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    {:ok,  %TodoList{}}
  end

  def new(), do: %TodoList{}

  def new(entries) do
    entries
    |> Enum.map(&TodoEntry.new(&1))
    |> Enum.each(&TodoList.add_entry(&1))
  end

  def add_entry(%TodoEntry{} = entry) do
    GenServer.cast(__MODULE__, {:post, entry})
  end

  def update_entry(entry_id, updater) do
    GenServer.cast(__MODULE__, {:update, entry_id, updater})
  end

  def delete_entry(entry_id) do
    GenServer.cast(__MODULE__, {:delete, entry_id})
  end

  def entries() do
    GenServer.call(__MODULE__, {:get})
  end

  def entries(date) do
    GenServer.call(__MODULE__, {:get, date})
  end

  def handle_call({:get}, _, todo_list) do
    {:reply, todo_list.entries, todo_list}
  end

  def handle_call({:get, date}, _, todo_list) do
    {:reply, get_entries(todo_list, date), todo_list}
  end

  def handle_cast({:post, %TodoEntry{} = entry}, todo_list) do
    new_entry = Map.put(entry, :id, todo_list.auto_id)
    new_entries = Map.put(todo_list.entries, todo_list.auto_id, new_entry)

    new_todo_list = %TodoList{todo_list | auto_id: todo_list.auto_id + 1, entries: new_entries}
    {:noreply, new_todo_list}
  end

  def handle_cast({:update, entry_id, updater}, todo_list) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error -> {:noreply, todo_list}
      {:ok, old_entry} ->
        old_entry_id = old_entry.id
        new_entry = %TodoEntry{id: ^old_entry_id} = updater.(old_entry)
        new_entries = Map.put(todo_list.entries, entry_id, new_entry)
        {:noreply, %TodoList{todo_list | entries: new_entries}}
    end
  end

  def handle_cast({:delete, entry_id}, todo_list) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error -> {:noreply, todo_list}
      {:ok, _} ->
        new_entries = Map.delete(todo_list.entries, entry_id)
        {:noreply, %TodoList{todo_list | entries: new_entries}}
    end
  end

  defp get_entries(todo_list, date) do
    todo_list.entries
    |> Stream.map(fn {_, v} -> v end)
    |> Enum.filter(&(&1.date == date))
  end
end
