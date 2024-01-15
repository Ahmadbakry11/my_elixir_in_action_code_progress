long_job = fn ->
  Process.sleep(2000)
  :some_result
end

task = Task.async(long_job)

result = Task.await(task)

run_query = fn ->
  Process.sleep(2000)
  "query result"
end

query_exec = fn -> run_query

1..5
|> Enum.map(&Task.async(fn -> run_query.(&1) end))
|> Enum.map(&Task.await(&1))


# all-or-nothing semantics
# Task.async/1 links the new task to the starter process.
# if a task process crashes during excution, the error will propagate to the starter process
# and it crashes too
1..10 |>
Enum.map(fn x ->
  Task.async(fn -> run_query.(x) end)
  if x == 5 do
    Process.exit(self(), :kill)
  end
end) |>
Enum.map(&Task.await(&1))

# non awaited task
# is an otp compliant wrapper around spawn_link

{:ok, pid} = Task.start_link(
  fn ->
    Process.sleep(10000)
    IO.puts("The non awaited task finished!")
  end
)

Process.exit(pid, :normal)
