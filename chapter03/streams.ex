defmodule Employee do
  def print_employees(employees) do
    employees
    |> Enum.with_index
    |> Enum.each(&IO.puts("#{elem(&1, 1)}.#{elem(&1, 0)}"))
  end

  def print_list(employees) do
    employees
    |> Stream.with_index
    |> Stream.map(&("#{elem(&1, 1)}.#{elem(&1, 0)}"))
    |> Enum.to_list
    |> Enum.each(&IO.puts(&1))
  end

  def salary_wage(list) do
    list
    |> Stream.filter(&(is_number(&1)))
    |> Stream.with_index
    |> Stream.map(&("#{elem(&1, 1)}.sqrt(#{elem(&1, 0)}): #{:math.sqrt(elem(&1, 0))}"))
    |> Enum.to_list
    |> Enum.each(&IO.puts/1)
  end
end
