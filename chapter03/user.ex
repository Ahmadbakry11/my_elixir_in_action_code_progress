defmodule User do
  defp extract_email(%{email: email}), do: {:ok, email}
  defp extract_email(_), do: {:error, "email not found"}

  defp extract_login(%{login: login}), do: {:ok, login}
  defp extract_login(_), do: {:error, "login not found"}

  defp extract_password(%{password: password}), do: {:ok, password}
  defp extract_password(_), do: {:error, "password not found"}

  def extract_user(input) do
    with {:ok, email} <- extract_email(input),
      {:ok, login} <- extract_login(input),
      {:ok, password} <- extract_password(input)
    do
     {:ok, {email, login, password}}
    end
  end
end
