defmodule Todo.Database do
  use GenServer

  @db_folder "./database"

  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    File.mkdir_p!(@db_folder)
    {:ok, nil}
  end

  def store(key, data) do
    GenServer.cast(__MODULE__, {:store, key, data})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def handle_cast({:store, key, data}, state) do
    spawn(fn ->
      file_name(key)
      |> File.write!(:erlang.term_to_binary(data))
    end)

    {:noreply, state}
  end

  def handle_call({:get, key}, caller, state) do
    spawn(fn ->
      todo_list  = case File.read(file_name(key)) do
        {:error, :enoent} -> nil
        {:ok, content} -> :erlang.binary_to_term(content)
      end

      GenServer.reply(caller, todo_list)
    end)

    {:noreply, state}
  end

  defp file_name(key) do
    Path.join(@db_folder, to_string(key))
  end
end
