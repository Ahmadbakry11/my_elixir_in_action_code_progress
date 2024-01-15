defmodule SimpleRegistry do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    :ets.new(
      __MODULE__,
      [
        :named_table,
        :public,
        write_concurrency: true
      ]
    )

    {:ok, nil}
  end

  def register(key = {_, pid}) do
    :ets.insert(__MODULE__, {key, pid})
  end

  def where_is(key) do
    case :ets.lookup(__MODULE__, key) do
      [{^key,  value}] -> value
      [] -> nil
    end
  end
end
