defmodule KeyValue do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    SimpleRegistry.register({__MODULE__, self()})
    {:ok, %{}}
  end

  def put(key, value) do
    IO.inspect({__MODULE__, self()})

    GenServer.cast(process_name(), {:put, key, value})
  end

  def get(key) do
    IO.inspect({__MODULE__, self()})

    GenServer.call(process_name(), {:get, key})
  end

  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  def handle_call({:get, key}, _, state) do
    {:reply, Map.get(state, key), state}
  end

  defp process_name() do
    SimpleRegistry.where_is({__MODULE__, self()})
  end
end
