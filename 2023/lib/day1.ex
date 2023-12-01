defmodule Day1 do
  import Utils
  @numbers ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

  def main() do
    read_from_file("1") |>
    Enum.map(fn line -> line |> String.codepoints end) |>
    Enum.map(fn line -> find_numbers([], line) end ) |>
    Enum.filter(fn list -> length(list) > 0 end) |>
    Enum.map(fn list -> hd(list)*10 + (Enum.reverse(list) |> hd) end) |>
    Enum.reduce(fn acc, el -> acc + el end) |>
    IO.puts()
  end

  @spec find_numbers([integer()], [char()]) :: [integer()]
  def find_numbers(acc, []) do acc end
  def find_numbers(acc, [head | tail]) do
    if head >= "0" and head <= "9" do
       find_numbers(acc ++ [String.to_integer(head)], tail)
    else
      case check_number(List.to_string([head] ++ tail), 1, @numbers) do
        [] -> find_numbers(acc, tail)
        num -> find_numbers(acc ++ num, tail)
      end
    end
  end

  def check_number(str, num, []) do [] end
  def check_number(str, num, [head | tail]) do
    if String.starts_with?(str, head) do
      [num]
    else
      check_number(str, num + 1, tail)
    end
  end
end
