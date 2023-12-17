defmodule AsyncDatabaseServe do
  def start() do
    spawn(&loop/0)
  end

  def run_query(server_pid, query) do
    send(server_pid, {:run_query, self(), query})
  end

  def get_result() do
    receive do
      {:query_result, result} -> result
    end
  end

  defp loop() do
    receive do
      {:run_query, sender_pid, query} ->
        send(sender_pid, {:query_result, async_query(query)})
      after
        40000 -> {:time_out, "no result found"}
    end

    loop()
  end

  defp async_query(query) do
    Process.sleep(2000)
    {query, :calendar.local_time()}
  end
end

# pool = 1..100 |> Enum.reduce(%{}, fn pid, acc -> Map.put(acc, pid, AsyncDatabaseServe.start()) end)

# 1..50 |>
# Enum.map(fn pid -> AsyncDatabaseServe.run_query(pool[pid], "query_#{pid}") end) |>
# Enum.map(fn _ -> AsyncDatabaseServe.get_result() end)
