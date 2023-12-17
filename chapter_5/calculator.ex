defmodule Calculator do
  def start() do
    spawn(fn -> loop(0) end)
  end

  def add(calculator_pid, value) do
    send(calculator_pid, {:add, value})
  end

  def subtract(calculator_pid, value) do
    send(calculator_pid, {:sub, value})
  end

  def div(calculator_pid, value) do
    send(calculator_pid, {:div, value})
  end

  def multiply(calculator_pid, value) do
    send(calculator_pid, {:mul, value})
  end

  def value(calculator_pid) do
    send(calculator_pid, {:val, self()})
    receive do
      {:result, value} -> value
    end
  end

  defp loop(state) do
    new_state = receive do
      message -> process_message(state, message)
    end

    loop(new_state)
  end

  defp process_message(state, {:add, value}), do: state + value
  defp process_message(state, {:sub, value}), do: state - value
  defp process_message(state, {:div, value}), do: state / value
  defp process_message(state, {:mul, value}), do: state * value
  defp process_message(state, {:val, sender}) do
    send(sender, {:result, state})
    state
  end

  defp process_message(state, invalid_request) do
    IO.puts "Calculator does not support this #{inspect(invalid_request)}"
    state
  end

  # The old loop() before refactoring as above
  # defp loop(state) do
  #   new_state = receive do
  #     {:add, value} -> state + value
  #     {:sub, value} -> state - value
  #     {:div, value} -> state / value
  #     {:mul, value} -> state * value
  #     {:val, sender} ->
  #       send(sender, {:result, state})
  #       state
  #     invalid_request ->
  #       IO.puts("Calculator does not support that #{invalid_request}")
  #       state
  #   end

  #   loop(new_state)
  # end
end
