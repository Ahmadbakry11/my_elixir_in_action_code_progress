defmodule ServerProcess do
  def start(callback_module) do
    spawn(fn ->
      initial_state = callback_module.init()
      loop(callback_module, initial_state)
    end)
  end

  def call(pid, request) do
    send(pid, {:call, request, self()})

    receive do
      {:response, response} -> response
    end
  end

  def cast(pid, request) do
    send(pid, {:cast, request})
  end

  defp loop(callback_module, state) do
    receive do
      {:call, request, caller} ->
        {reponse, new_state} = callback_module.handle_call(state, request)
        send(caller, {:response, response})
        loop(callback_module, new_state)

      {:cast, request} ->
        new_state = callback_module.handle_cast(state, request)
        loop(new_state)
    end
  end
end



defmodule TodoServer do
  def start() do
    ServerProcess.start()
  end

  def init() do
    TodoList.new()
  end

  def add_entry(server_pid, entry) do
    TodoServer.cast(server_pid, {:put, entry})
  end

  def handle_cast(state, {:put, entry}) do
    TodoList.add_entry(state, entry)
  end
end


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
