defmodule Todo.Database do
  use GenServer

  alias Todo.Databaseworker

  @db_folder "todo_database"
  @db_workers 3

  def start() do
    GenServer.start(__MODULE__, nil)
  end

  def init(_) do
    send(self(), {:create_db_folder})
    pool = create_workers_pool()
    {:ok, pool}
  end

  def get_worker() do
    GenServer.call(__MODULE__, {:get_worker})
  end

  def store(key, data) do
    Databaseworker.store(get_worker(), key, data)
  end

  def get(key) do
    Databaseworker.get(get_worker(), key)
  end

  def handle_info({:create_db_folder}, state) do
    Process.register(self(), __MODULE__)
    File.mkdir_p!(@db_folder)

    {:noreply, state}
  end

  # see point **1**
  def handle_call({:get_worker}, _, {[pid_index | indexes], pool}) do
    worker = Map.get(pool, "worker_#{pid_index}")
    {:reply, worker, {indexes ++ [pid_index], pool}}
  end

  defp create_workers_pool() do
    indexs = Enum.to_list(1..@db_workers)
    pool = Enum.reduce(indexs, %{}, &Map.put(&2, "worker_#{&1}", elem(Databaseworker.start(@db_folder), 1)))

    {indexs, pool}
  end
end

# **1**
# we can have another lovely and so simple solution to get the dedicated Databaseworker
# that can handle such todo list using the erlang function phash2(term, range)

# create a pool of workers.A map which has the following shape
# {1 => worker_pid_1, 2 => worker_pid_2, 3 => worker_pid_3}
# :erlang.phash2(todo_list_name, 3)
# This function returns an integer that is equivalent to todo_list_name.
# this integer is the key of the pool of workers map.
