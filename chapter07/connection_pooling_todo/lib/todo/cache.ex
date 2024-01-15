defmodule Todo.Cache do
  use GenServer
  alias Todo.Server

  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    Todo.Database.start()
    {:ok, %{}}
  end

  def server_process(todo_list_name) do
    GenServer.call(__MODULE__, {:get, todo_list_name})
  end

  def handle_call({:get, todo_list_name}, _, cache) do
    case Map.fetch(cache, todo_list_name) do
      :error ->
        {:ok, pid} = Server.start(todo_list_name)
        new_cache = Map.put(cache, todo_list_name, pid)
        {:reply, pid, new_cache}

      {:ok, pid} ->
        {:reply, pid, cache}
    end
  end
end

# ===============================

# e1 = Todo.Entry.new(~D[2020-11-12], "Dentist")
# e2 = Todo.Entry.new(~D[2020-11-12], "shopping")
# e3 = Todo.Entry.new(~D[2020-11-15], "Gym")
