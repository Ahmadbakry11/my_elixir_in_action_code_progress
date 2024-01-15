{:ok, pid} = Agent.start_link(fn -> %{name: "Bob", age: 20} end)

age = Agent.get(pid, fn state -> state.age end)

Agent.update(pid, fn state -> %{state | age: state.age + 5} end)

age = Agent.get(pid, fn state -> state.age end)

# ========================================

{:ok, pid} = Agent.start_link(fn -> 0 end)

# concurrent requests by different processes are serialized
1..9 |>
Enum.each(fn _ ->
  spawn(fn ->
    Agent.update(pid, fn state -> state + 1 end)
  end)
end)
# agents ate built on top of GenServer
