defmodule Todo.Server do
  use GenServer
  alias Todo.List
  alias Todo.Entry

  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    {:ok,  %List{}}
  end

  def add_entry(entry) do
    GenServer.cast(__MODULE__, {:post, entry})
  end

  def add_entries(entries) do
    GenServer.cast(__MODULE__, {:post, entries})
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

  def handle_cast({:post, %Entry{} = entry}, todo_list) do
    {:noreply, List.add_entry(todo_list, entry)}
  end

  def handle_cast({:post, [_ | _] = entries}, todo_list) do
    {:noreply, List.add_entries(todo_list, entries)}
  end

  def handle_cast({:update, entry_id, updater}, todo_list) do
    {:noreply, List.update_entry(todo_list, entry_id, updater)}
  end

  def handle_cast({:delete, entry_id}, todo_list) do
    {:noreply, List.delete_entry(todo_list, entry_id)}
  end

  def handle_call({:get}, _, todo_list) do
    {:reply, List.entries(todo_list), todo_list}
  end

  def handle_call({:get, date}, _, todo_list) do
    {:reply, List.entries(todo_list, date), todo_list}
  end
end

# e1 = Todo.Entry.new(~D[2020-11-12], "Dentist")
# e2 = Todo.Entry.new(~D[2020-11-12], "shopping")
# e3 = Todo.Entry.new(~D[2020-11-15], "Gym")

# entries = [
#   %{date: ~D[2020-11-13], title: "cooking food"},
#   %{date: ~D[2020-11-14], title: "biking"},
#   %{date: ~D[2020-11-17], title: "airport"}
# ]

# updater = fn x -> %Todo.Entry{id: x.id, date: x.date, title: "reading"} end

# Todo.Server.start()
# Todo.Server.add_entry(e1)
# Todo.Server.add_entry(e2)
# Todo.Server.add_entry(e3)


# Todo.Server.add_entries(entries)

# Todo.Server.update_entry(1, updater)

# Todo.Server.delete_entry(4)
