# pattern = term
# all fields in the pattern must exist in the term
# The term can have fields that do not exist in the patterns

defmodule Fraction do
  defstruct a: nil, b: nil

  def new(a, b) do
    %Fraction{a: a, b: b}
  end

  def add(%Fraction{a: a1, b: b1}, %Fraction{a: a2, b: b2}) do
    new(
      (a1 * b1) + (a2 * b2),
      b1 * b2
    )
  end

  def add(_, _), do: {:error, "incorrect fraction"}

  def value(%Fraction{a: a, b: b}) do
    a / b
  end

  def value(_), do: {:error, "incorrect fraction"}
end
