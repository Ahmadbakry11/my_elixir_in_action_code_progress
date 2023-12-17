defmodule DatabaseServer do
  def start() do
    connection = :rand.uniform(1000)
    spawn(fn -> loop(connection) end)
  end

  def run_query(server_pid, query) do
    sender_pid = self()
    send(server_pid, {:query_def, sender_pid, query})
  end

  def get_result() do
    receive do
      {:query_result, result} -> result
    end
  end

  defp loop(connection) do
    receive do
      {:query_def, sender_pid, query} ->
        send(sender_pid, {:query_result, async_query(connection, query)})
    end

    loop(connection)
  end

  defp async_query(connection, query) do
    "Connection #{connection}: query result of query_#{query}"
  end
end

# pool = 1..100 |> Enum.map(fn _ -> DatabaseServer.start() end)

# 1..50
# |> Enum.map(&DatabaseServer.run_query(Enum.at(pool, :rand.uniform(100) - 1), &1))
# |> Enum.map(fn _ -> DatabaseServer.get_result() end)
