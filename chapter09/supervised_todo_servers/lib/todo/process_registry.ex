defmodule Todo.ProcessRegistry do
  def start_link() do
    Registry.start_link(name: __MODULE__, keys: :unique)
  end

  def child_spec(_) do
    Supervisor.child_spec(
      Registry,
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    )
  end

  def via_tuple(key) do
    {:via, Registry, {__MODULE__, key}}
  end
end
