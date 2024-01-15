defprotocol Utility do
  def type(value)
end

defimpl Utility, for: BitString do
  def type(_), do: "string"
end

defimpl Utility, for: Integer do
  def type(_), do: "integer"
end

defimpl Utility, for: Atom do
  def type(_), do: "atom"
end
