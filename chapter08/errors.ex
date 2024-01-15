defmodule Errors do

end

try_helper = fn fun ->
  IO.puts("I am calling the function")
  try do
    fun.()
  catch error_type, error_value ->
    IO.puts("Error\n #{inspect(error_type)} \n #{inspect(error_value)}")
  end
end

spawn(fn ->
  spawn_link(fn ->
    Process.sleep(2000)
    IO.puts("I am process 2")
  end)

  raise("Process 1 crashed")
end)

spawn(fn ->
  spawn_link(fn ->
    Process.sleep(2000)
    IO.puts("I am process 2")
  end)

  exit(:normal)
end)

spawn(fn ->
  spawn(fn ->
    Process.sleep(2000)
    IO.puts("I am process 2")
  end)

  raise("Process 1 crashed")
end)

spawn(fn ->
  Process.flag(:trap_exit, true)
  spawn_link(fn ->
    Process.flag(:trap_exit, true)
    IO.puts("I am process 2")
    receive do
      message -> IO.inspect(message)
    end
  end)
  raise("process 1 crashed!")

  receive do
    message -> IO.inspect(message)
  end
end)



target_pid = spawn(fn -> Process.sleep(7000) end)
monitor_ref = Process.monitor(target_pid)

receive do
  message -> IO.inspect(message)
end


Registry.start_link(name: :my_registery, keys: :unique)
spawn(fn ->
  Registry.register(:my_registery, {:db_worker, 3}, nil)

  receive do
    message -> IO.inspect(message)
  end
end)
