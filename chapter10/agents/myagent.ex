# agents ate built on top of GenServer

defmodule MyAgent do
  def start_link(_) do
    GenServer.start_link(__MODULE__, fun)
  end

  def init(fun) do
    {:ok, fun.()}
  end

  def get(pid, fun) do
    GenServer.call{pid, {:get, fun}}
  end

  def update(pid, fun) do
    GenServer.call(pid, {:put, fun})
  end

  def handle_call({:get, fun}, _, state) do
    {:reply, fun.(state), state}
  end

  def handle_call({:put, fun}, _, state) do
    {:reply, :ok, fun.(state)}
  end
end
