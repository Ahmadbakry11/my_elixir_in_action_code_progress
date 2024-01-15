defmodule NaturalSum do
  def print(0), do: IO.puts(0)

  def print(n) when is_integer(n) and n > 0 do
    print(n-1)
    IO.puts n
  end

  def print(_), do: IO.puts("Not a natural number")
end

defmodule ListHelper do
  def sum([]), do: 0
  def sum([hd | tail]) do
    hd + sum(tail)
  end

  def list_sum(list) do
    do_sum(list, 0)
  end

  defp do_sum([], new_sum), do: new_sum

  defp do_sum([hd | tail], new_sum) do
    do_sum(tail, hd + new_sum)
  end
end
