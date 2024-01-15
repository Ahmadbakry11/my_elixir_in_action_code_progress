defmodule Test do
  def area({:rectangle, [a, b]}) do
    a * b
  end

  m = %{a: 5}
  Map.update(m, :a, 19, fn x -> x * 2 end)
  Map.update(m, :b, 19, fn x -> x * 2 end)

  Map.update(todo_list, date, [title], fn titles -> [title | titles] end)
end

# new item: date --> [title]
# Map.update(map_instance, key, default_value_if_key_is_not_found, fn_to_be_applied_to_each_element_in_case_of_existing_key)
