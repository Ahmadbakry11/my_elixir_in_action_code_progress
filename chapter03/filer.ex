defmodule User do
  def login_fields(user) do
    case Enum.filter(
      ["login", "email", "password"],
      &(not Map.has_key?(user, &1))
    ) do
      [] -> get_user_map(user)
      missing_fields -> missing_fields
    end
  end

  defp get_user_map(user) do
    Enum.reduce(["login", "email", "password"], %{},
    &(Map.put(&2, String.to_atom(&1),  Map.get(user, &1))))
  end
end
