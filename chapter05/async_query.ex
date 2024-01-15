run_query = fn query_def  ->
  "query_result of #{query_def}"
end

async_query = fn query ->
  caller = self()
  spawn(fn -> send(caller, {:query_result, run_query.(query)}) end)
end

query_result = fn ->
  receive do
    {:query_result, result} -> result
  end
end

1..5 |> Enum.map(&async_query.("query_#{&1}")) |> Enum.map(fn _ -> query_result.() end)
