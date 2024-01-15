defmodule NumHelper do
  def sum(list) do
    list
    |> Enum.reduce(0,
      fn
        x, acc when is_number(x) -> x + acc
        _, acc -> acc
      end)
  end

  def sum_list(list) do
    list
    |> Enum.reduce(0, &add_nums/2)
  end

  defp add_nums(n, m) when is_number(n), do: n + m

  defp add_nums(_, m), do: m
end
