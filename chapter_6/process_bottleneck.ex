defmodule EchoServer do
  def start() do
    pid = spawn(&loop/0)
  end

  def send_message(echo_server, message) do
    send(echo_server, {:msg, self(), message})

    receive do
      {:msg_back, message} -> message
    end
  end

  @doc """
    an implementation for the sending messages
    by assigning a new server_process for each request
    instead of making all the requests handled sequentially
    by one server process.Here the interface is different
  """
  def send_msg(message) do
    pid = start()
    send(pid, {:msg, self(), message})

    receive do
      {:msg_back, message} -> message
    end
  end

  defp loop() do
    receive do
      {:msg, caller, message} ->
        Process.sleep(5000)
        send(caller, {:msg_back, message})

      other -> log_unknown_message(other)  #prevent the buildup of process mailbox
    end

    loop()
  end

  defp log_unknown_message(message) do
    IO.puts("I received an unknown message")
    IO.inspect(message)
  end
end

# pid = EchoServer.start()
# 1..5 |>
# Enum.each(fn x ->
#   spawn(fn ->
#     IO.puts("sending message no. #{x}")
#     EchoServer.send_message("message_#{x}")
#     IO.puts("now I received it")
#   end)
# end)
