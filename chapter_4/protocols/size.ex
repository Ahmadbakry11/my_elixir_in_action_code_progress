defprotocol Size do
  def size(data)
end

defimpl Size, for: BitString do
  def size(data), do: byte_size(data)
end

defimpl Size, for: Map do
  def size(map), do: map_size(map)
end

defimpl Size, for: Tuple do
  def size(tuple), do: tuple_size(tuple)
end

defimpl Size, for: MapSet do
  def size(map_set), do: MapSet.size(map_set)
end

# For any, we have 2 options
# 1- derive
# 2- fallback

# derive
defimpl Size, for: Any do
  def size(_), do: 0
end

defmodule User do
  @derive [Size]
  defstruct [:age, :name]

  def new(), do: %User{}
end

# user = User.new()
# Size.size(user)

# fallback to Any

defprotocol Utility do
  @fallback_to_any true

  def type(value)
end

defimpl Utility, for: Intger do
  def type(_), do: "integer"
end

defimpl Utility, for: Any do
  def type(_), do: "Something"
end
