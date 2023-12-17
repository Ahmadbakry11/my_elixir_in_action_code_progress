# 1- A list_len/1 function that calculates the length of a list
# 2- A range/2 function that takes two integers, from and to , and returns a list of all
# numbers in the given range
# 3- A positive/1 function that takes a list and returns another list that contains only
# the positive numbers from the input list

defmodule ListHelper do
  @doc "list_length fn in the form of tail/call optimization"
  def list_length(list) do
    get_length(list, 0)
  end

  defp get_length([], l), do: l

  defp get_length([_ | tail], l) do
    l =  l + 1
    get_length(tail, l)
  end

  @doc "range fn in the form of tail/call optimaization"
  def range(from, to) when is_integer(from) and is_integer(to) do
    get_list(from, to, [])
  end

  def range(_, _), do: "invalid arguments"

  defp get_list(to, to, list), do: [to | list]

  defp get_list(from, to, list) when from < to do
    get_list(from + 1, to, [from | list])
  end

  defp get_list(from, to, list) when from > to do
    get_list(from - 1, to, [from | list])
  end

  @doc "positive fn in the form of tail/call optimaization"

  def positive(list) do
    get_positive_list(list, [])
  end

  defp get_positive_list([], positive_list), do: positive_list

  defp get_positive_list([hd | tail], list) when hd > 0 do
    get_positive_list(tail, [hd | list])
  end

  defp get_positive_list([hd | tail], list) when hd < 0 do
    get_positive_list(tail, list)
  end
end
