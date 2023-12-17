test_number =
  fn
    x when is_number(x) and x  > 0  ->
      :positive
    0 -> :zero
    x when is_number(x) and x < 0 ->
      :negative
  end


  defmodule NumHelper do
    def test(x) when x < 0, do: :negative
    def test(0), do: :zero
    def test(x), do: :positive

    def double(x) when is_number(x), do: x * 2
    def double(x) when is_binary(x), do: x <> x

    def min(a, b) do
      unless a < b, do: b, else: a
    end

    def max(a, b) do
      cond do
        a >= b -> a
        true -> b
      end
    end

    def symbol(num) do
      cond do
        num == 1 -> :one
        num == 2 -> :two
        num ==  3 -> :three
        true -> :unknown
      end
    end

    def state(a) do
      case a != nil and a  do
        true -> :truthy
        false -> false
      end
    end
  end

  defmodule ListHelper do
    def empty?([]), do: true
    def empty?([_, _]), do: false
  end

  defmodule Fact do
    def fact(0), do: 1
    def fact(n), do: n * fact(n-1)
  end

  # if 5 > 3 do
  #   :five
  # else
  #   :three
  # end

  # if 5 > 3, do: 5, else: 3

  # if a > b do: true, else: false

  # def max(a, b) do
  #   if a > b do: a, else: b
  # end
