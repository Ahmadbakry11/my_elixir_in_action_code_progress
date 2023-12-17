defmodule KeyValueStore do
  use GenServer

  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  @impl GenServer
  def init(_) do
    # {:stop, "no more work"}
    IO.inspect(self())
    :timer.send_interval(5000, {:cleanup, %{}})
    {:ok, %{}}
  end

  def put(key, value) do
    GenServer.cast(__MODULE__, {:put, key, value})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def get_store() do
    GenServer.call(__MODULE__, {:get})
  end

  def cleanup() do
    send(__MODULE__, {:cleanup, %{}})
  end

  def stop() do
    send(__MODULE__, {:stop, :normal, %{}})
  end

  @impl GenServer
  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  @impl GenServer
  def handle_call({:get, key}, _, state) do
    {:reply, Map.get(state, key), state}
  end

  @impl GenServer
  def handle_call({:get}, _,  state) do
    {:reply, state, state}
  end

  @impl GenServer
  def handle_info({:cleanup, new_state}, _) do
    IO.puts("performing some state cleanup")
    {:noreply, new_state}
  end

  @impl GenServer
  def handle_info({:stop, reason, new_state}, _) do
    {:stop, reason, new_state}
  end
end

# to illustrate the handle_info callback
# you can send the server process initialized by GenServer
# any message and as long as this message is neither a call nor a cast
# it can be handled by the Genserve using the handle_info callbacl like the below message

# def cleanup() do
#   send(__MODULE__, {:cleanup, %{}})
# end

# to stop the server process
# send a message to the server process that can be handled
# by the handle_info message and this callback is assumed
# to return {:error, reason, new_state}
# if the reason is something else rather than :normal,
# the process will be terminated and an error will be raised lke below
# ==================================================
#   [error] GenServer KeyValueStore terminating
# ** (stop) "need to refresh the data"
# Last message: {:stop, "need to refresh the data", %{}}
# State: %{}
# {:stop, "need to refresh the data", %{}}
# ==================================================
# In case of :normal as a reason
# this is the return value
# {:stop, :normal, %{}}
# ==================================================
# :normal as a reason is sent when stopping the server is a normal course of action
# other reasons is for an unexpected error
# *******************************************************************

KeyValueStore.start()
KeyValueStore.put(:key1, "value1")
KeyValueStore.put(:key2, "value2")
KeyValueStore.put(:key3, "value3")
KeyValueStore.put(:key4, "value4")
KeyValueStore.put(:key5, "value5")
KeyValueStore.get_store()
