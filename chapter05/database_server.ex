defmodule DatabaseServer do
  def start() do
    spawn(fn -> loop() end)
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

  # we return time stamp to indicate that multiple requests
  # will be treated sequentially
  defp async_query(query) do
    Process.sleep(10000)
    {query, :calendar.local_time()}
  end
end

server_pid = DatabaseServer.start()

DatabaseServer.run_query(server_pid, "query_0")
DatabaseServer.run_query(server_pid, "query_1")
DatabaseServer.run_query(server_pid, "query_2")

1..3 |> Enum.map(fn _ -> DatabaseServer.get_result() end)
