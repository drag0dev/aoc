defmodule Day9 do
  import Utils
  def main() do
    read_from_file("9") |>
    Enum.map(fn line -> parse_line([], 0, 1, false, String.codepoints(line)) end) |>
    # Enum.map(fn line -> process_array(line) end) |>
    Enum.map(fn line -> process_array_part_two(line) end) |>
    Enum.reduce(0, fn x, acc -> x + acc end) |>
    IO.inspect()
  end

  def process_array(nums) do
    if Enum.all?(nums, fn x -> x == 0 end) do
      0
    else
      new_nums =
        Enum.chunk_every(nums, 2, 1, :discard) |>
        Enum.map(fn [a, b] -> b-a end)
      len = length(nums)
      Enum.at(nums, len-1) + process_array(new_nums)
    end
  end

  def process_array_part_two(nums) do
    if Enum.all?(nums, fn x -> x == 0 end) do
      0
    else
      new_nums =
        Enum.chunk_every(nums, 2, 1, :discard) |>
        Enum.map(fn [a, b] -> b-a end)
      Enum.at(nums, 0) - process_array_part_two(new_nums)
    end
  end

  def parse_line(acc, num, neg, flag, []) do if flag do acc ++ [num*neg] else acc end end
  def parse_line(acc, num, neg, flag, [head | tail]) do
    if head == "-" do
      parse_line(acc, num, -1, flag, tail)
    else
      if head >= "0" and head <= "9" do
        parse_line(acc, num*10 + String.to_integer(head), neg, true, tail)
      else
        if flag do
          parse_line(acc ++ [num*neg], 0, 1, false, tail)
        else
          parse_line(acc, 0, 1, false, tail)
        end
      end
    end
  end
end
