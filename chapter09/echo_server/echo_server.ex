defmodule EchoServer do
  use GenServer

  def start(_) do
    IO.puts("Starting the Echo Server.....")
    GenServer.start_link(__MODULE__, nil, name: via_tuple())
  end

  def child_spec(arg) do
    %{
      id: EchoServer,
      start: {EchoServer, :start, [arg]}
    }
  end

  def init(_) do
    {:ok, nil}
  end

  def call(message) do
    GenServer.call(process_id(), {:echo, message})
  end

  def handle_call({:echo, message}, _, state) do
    {:reply, message, state}
  end

  defp via_tuple() do
    {:via, Registry, {:my_reg, {__MODULE__, :echo}}}
  end

  def process_id() do
    ProcessRegistry.get({__MODULE__, :echo})
  end
end

defmodule ProcessRegistry do
  use GenServer

  def start(_) do
    IO.puts("Starting the ProcessRegistry.....")
    Registry.start_link(name: :my_reg, keys: :unique)
  end

  def init(_) do
    {:ok, nil}
  end

  def child_spec(arg) do
    %{
      id: ProcessRegistry,
      start: {ProcessRegistry, :start, [arg]}
    }
  end

  def name() do
    :my_reg
  end

  def get(key) do
    [{pid, _}] = Registry.lookup(:my_reg, key)
    pid
  end

  def register(key) do
    GenServer.cast(__MODULE__, {:put, key})
  end

  def handle_call({:get, key}, _, state) do
    [{pid, _}] = Registry.lookup(:my_reg, key)
    {:reply, pid, state}
  end

  def handle_cast({:put, key}, state) do
    Registry.register(:my_reg, key, nil)
    {:noreply, state}
  end
end

defmodule EchoSystem do
  def start() do
    Supervisor.start_link(
      [
        ProcessRegistry,
        EchoServer
      ],
      strategy: :one_for_one
    )
  end
end
