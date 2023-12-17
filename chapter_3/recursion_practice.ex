# 1- A list_len/1 function that calculates the length of a list
# 2- A range/2 function that takes two integers, from and to , and returns a list of all
# numbers in the given range
# 3- A positive/1 function that takes a list and returns another list that contains only
# the positive numbers from the input list

defmodule ListHelper do
  @doc "list length function"
  def list_length([]), do: 0

  def list_length([_ | tail]) do
    1 + list_length(tail)
  end

  @doc "range to list function"
  def range(to, to), do: [to]

  def range(from, to) when is_integer(from) and is_integer(to) and from < to do
    [from] ++ range(from + 1, to)
  end

  def range(from, to) when is_integer(from) and is_integer(to) and from > to do
    [from] ++ range(from - 1, to)
  end

  def range(_, _), do: "invalid arguments"

  @doc "takes a list and returns a new list with positive numbers only"
  def positive([]), do: []

  def positive([hd | tail]) do   #can be represented in multicluase form
    if hd > 0 do
      [hd] ++ positive(tail)
    else
      positive(tail)
    end
  end
end
