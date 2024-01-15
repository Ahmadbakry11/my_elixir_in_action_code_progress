# provide multiple definitions of the same function with the same arity

defmodule Geometry do
  def area({:rectangle, a, b}) do
    a * b
  end

  def area({:square, a}) do
    a * a
  end

  def area({:circle, r}) do
    3.14 * r * r
  end

  def area(unknown) do
    {:error, {"unknown shape", unknown}}
  end
end

IO.puts Geometry.area({:rectangle, 2, 5})

IO.puts Geometry.area({:square, 5})

IO.puts Geometry.area({:circle, 5})

IO.puts Geometry.area({:triangle, 5, 7, 3})
