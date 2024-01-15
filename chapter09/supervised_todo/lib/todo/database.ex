defmodule Todo.Database do
  use GenServer

  alias Todo.Databaseworker

  @db_folder "todo_database"
  @db_workers 3

  def start_link(_) do
    IO.puts("Starting Todo Database.....")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    File.mkdir_p!(@db_folder)
    {:ok, create_workers_pool()}
  end

  def get_worker(key) do
    GenServer.call(__MODULE__, {:get_worker, key})
  end

  def store(key, data) do
    key
    |> get_worker()
    |> Databaseworker.store(key, data)
  end

  def get(key) do
    key
    |> get_worker()
    |> Databaseworker.get(key)
  end

  def handle_call({:get_worker, key}, _, state) do
    worker = Map.get(state, :erlang.phash2(key, 3))
    {:reply, worker, state}
  end

  defp create_workers_pool() do
    for i <- 1..@db_workers, into: %{} do
      {:ok, pid} = Todo.Databaseworker.start_link(@db_folder)
      {i - 1, pid}
    end
  end
end
