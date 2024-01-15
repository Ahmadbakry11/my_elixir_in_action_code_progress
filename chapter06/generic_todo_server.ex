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
        {response, new_state} = callback_module.handle_call(request, state)
        send(caller, {:response, response})
        loop(callback_module, new_state)

      {:cast, request} ->
        new_state = callback_module.handle_cast(request, state)
        loop(callback_module, new_state)
    end
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

  def init() do
    %TodoList{}
  end

  def start() do
    ServerProcess.start(TodoList)
  end

  def new(pid, entries) do
    ServerProcess.cast(pid, {:post, entries})
  end

  def new(), do: %TodoList{}

  def add_entry(pid, %TodoEntry{} = entry) do
    ServerProcess.cast(pid, {:post, entry})
  end

  def update_entry(pid, entry_id, updater) do
    ServerProcess.cast(pid, {:update, entry_id, updater})
  end

  def delete_entry(pid, entry_id) do
    ServerProcess.cast(pid, {:delete, entry_id})
  end

  def entries(pid) do
    ServerProcess.call(pid, {:get})
  end

  def entries(pid, date) do
    ServerProcess.call(pid, {:get, date})
  end

  def handle_call({:get}, todo_list) do
    {todo_list.entries, todo_list}
  end

  def handle_call({:get, date}, todo_list) do
    {get_entries(todo_list, date), todo_list}
  end

  def handle_cast({:post, [_ | _] = entries}, todo_list) do
    entries
    |> Enum.map(&TodoEntry.new(&1))
    |> Enum.reduce(todo_list, &handle_cast({:post, &1}, &2))
  end

  def handle_cast({:post, entry}, todo_list) do
    new_entry = Map.put(entry, :id, todo_list.auto_id)
    new_entries = Map.put(todo_list.entries, todo_list.auto_id, new_entry)

    %TodoList{todo_list | auto_id: todo_list.auto_id + 1, entries: new_entries}
  end

  def handle_cast({:update, entry_id, updater}, todo_list) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error -> todo_list
      {:ok, old_entry} ->
        old_entry_id = old_entry.id
        new_entry = %TodoEntry{id: ^old_entry_id} = updater.(old_entry)
        new_entries = Map.put(todo_list.entries, entry_id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def handle_cast({:delete, entry_id}, todo_list) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error -> todo_list
      {:ok, _} ->
        new_entries = Map.delete(todo_list.entries, entry_id)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  defp get_entries(todo_list, date) do
    todo_list.entries
    |> Stream.map(fn {_, v} -> v end)
    |> Enum.filter(&(&1.date == date))
  end


  # def update_entry(pid, %TodoEntry{} = new_entry) do
  #   ServerProcess.cast(pid, {:update, new_entry.id, fn _ })
  # end

  # def handle_cast({:update, entry_id, updater}, todo_list) do
  #   case Map.fetch(todo_list.entries, entry_id) do
  #     :error -> todo_list
  #     {:ok, old_entry} ->
  #       old_entry_id = old_entry.id
  #       new_entry = %TodoEntry{id: ^old_entry_id} = updater.(old_entry)
  #       new_entries = Map.put(todo_list.entries, entry_id, new_entry)
  #       %TodoList{todo_list | entries: new_entries}
  #   end
  # end

  # def handle_cast({:update, new_entry}, todo_list) do
  #   handle_cast({:update, entry_id, updater}, todo_list)
  # end

  # def update_entry(todo_list, %TodoEntry{} = new_entry) do
  #   update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
  # end
end
