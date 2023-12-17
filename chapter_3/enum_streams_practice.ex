# Using large_lines!/1 as a model, write the following functions:
# *  A lines_lengths!/1 that takes a file path and returns a list of numbers, with
#     each number representing the length of the corresponding line from the file.
# *  A longest_line_length!/1 that returns the length of the longest line in a file.
# *  A longest_line!/1 that returns the contents of the longest line in a file.
# *  A words_per_line!/1 that returns a list of numbers, with each number rep-
# resenting the word count in a file. Hint: to get the word count of a line, use
# length(String.split(line)) .

@moduledoc """
FileHandler handles some of the processes related to files and associated lines
"""
defmodule FileHandler do
  @doc """
    get all the lines of the file in the path.
  """
  def get_lines!(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.replace(&1, "\r", ""))
    |> Stream.with_index
    |> Stream.map(&Tuple.append(&1, String.length(elem(&1, 0))))
    |> Enum.to_list()
    |> Enum.sort_by(&(elem(&1, 2)), :desc)
  end

  @doc """
  return a list of the file lines lengthes
  """
  @spec lines_lengths!(String.t()) :: [{String.t(), integer, integer}]
  def lines_lengths!(path) do
    path
    |> get_lines!
    |> Enum.map(&elem(&1, 2))
  end

  def longest_line_length!(path) do
    path
    |> lines_lengths!
    |> List.first
  end

  def longest_line!(path) do
    path
    |> get_lines!
    |> List.first
    |> elem(0)
  end

  def words_per_line!(path) do
    path
    |> get_lines!
    |> Enum.map(&String.split(elem(&1, 0)))
  end
end
