run_query = fn query_def ->
  Process.sleep(2000)
  "#{query_def} result"
end

async_query = fn query_def ->
  spawn(fn -> IO.puts(run_query.(query_def)) end)
end


receive_message = fn ->
  spawn(fn -> receive do
    {:ok, message} -> IO.puts message
    _ -> {:error, "not_received"}
  end
end)
end


check_mailbox = fn ->
  spawn(
    fn ->
      receive do
        message -> IO.inspect(message)
      after
        5000 -> IO.puts("empty mail box")
      end
    end
  )
end

receive_messages = fn ->
  receive do
    message -> IO.inspect(message)
  end
end

check_mailbox = fn ->
  spawn(fn -> receive_messages.() end)
end

# modified_async_query
async_query = fn query_def ->
  caller = self()
  spawn(fn ->  send(caller, {:query_result, run_query.(query_def)})  end)
end

# run_query = fn query ->
#   Process.sleep(2000)
#   "#{query} result"
# end
# async_query = fn query_def ->
#   caller = self()
#   spawn(fn -> send(caller, {:query_result, run_query.(query_def)}) end)
# end

# check_mailbox = fn ->
#   receive do
#     message -> IO.inspect(message)
#   end
# end

run_query = fn query_def ->
  Process.sleep(2000)
  "query #{query_def} result"
end

async_query = fn query ->
  spawn(fn ->
    send(self(), run_query.(query))
  end)
end

dequeue_message = fn ->
  receive do
    message -> message
  end
end

check_mailbox = fn ->
  spawn(fn -> dequeue_message.() end)
end


1..5 |> Enum.map(&async_query.(&1)) |> Enum.each(fn _ -> spawn(fn -> dequeue_message.()  end) end)
